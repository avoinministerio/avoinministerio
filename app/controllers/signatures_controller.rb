# #encoding: UTF-8

require 'date'

require 'signatures_controller_helpers'

$ALLOW_SIGNING_MULTIPLE_TIMES = ENV['ALLOW_SIGNING_MULTIPLE_TIMES']

class SignaturesController < ApplicationController

  include SignaturesControllerHelpers

  before_filter :authenticate_citizen!
  before_filter :check_if_idea_can_be_signed, :except => [:selected_free_service,
                                                          :returning,
                                                          :cancelling,
                                                          :rejecting,
                                                          :finalize_signing,
                                                          :shortcut_finalize_signing,
                                                          :signing_success,
                                                          :signing_failure,
                                                        ]

  respond_to :html

  def introduction
  end

  def approval
  end

  def fill_in_acceptances(signature)
    signature.accept_general       = params[:accept_general]
    signature.accept_non_eu_server = params[:accept_non_eu_server]
    signature.accept_publicity     = params[:accept_publicity]
    signature.accept_science       = params[:accept_science]
  end

  def service_selection
#    @signature = Signature.create_with_citizen_and_idea(current_citizen, Idea.find(params[:id]))
    @idea = Idea.find(params[:id])

    if not $ALLOW_SIGNING_MULTIPLE_TIMES and check_previously_signed(current_citizen, params[:id])
      @error = "Aiemmin allekirjoitettu"
      return
    end

    if check_previously_signed(current_citizen, params[:id])
      @info = "Idea on jo aiemmin allekirjoitettu, mutta uudelleenallekirjoittaminen on sallittua nyt vielä testivaiheessa"
    end
    @signature = Signature.new()
    @signature.idea                   = @idea
    @signature.idea_title             = @idea.title
    @signature.idea_date              = @idea.updated_at
    @signature.citizen                = current_citizen
    @signature.firstnames             = current_citizen.first_names
    @signature.lastname               = current_citizen.last_name
    @signature.state                  = "initial"
    @signature.stamp                  = DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s
    @signature.started                = Time.now
    @signature.occupancy_county       = ""
    @signature.service                = nil
#    # TODO: creation is now too late, so let's fake the data for development, needs to be cleared away
#    # FIXME: this is not even needed in signing so should not be passed
    @signature.accept_general         = true
    @signature.accept_non_eu_server   = true
    @signature.accept_publicity       = "Normal"
    @signature.accept_science         = true
    p @signature.valid?
    p @signature.errors.full_messages
    begin
      unless @signature.save
        p @signature
        raise "couldn't save" 
      end
    rescue Exception => e
      p e
      puts e.backtrace.join("\n")
    end

    services
    @parameters_and_urls = {}
    @services.each {|service| @parameters_and_urls[service[:name]] = signing_service_parameters_and_url(@signature, service)}
  end

  def requestor_secret
    config.signature_secret
  end

  def requestor_identifying_mac(parameters)
    mapped_params = 
      [:idea_id, :idea_title, :idea_date, :idea_mac, 
       :citizen_id, 
       :accept_general, :accept_non_eu_server, :accept_publicity, :accept_science,
       :service, 
      ].map do |key| 
        raise "unknown param #{key}" unless parameters[:message].has_key? key
        [key, parameters[:message][key]]
      end +
      [:success_url, :failure_url].map do |key| 
        raise "unknown param #{key}" unless parameters[:options].has_key? key
        [key, parameters[:options][key]]
      end +
      [:last_fill_first_names, :last_fill_last_names, :last_fill_birth_date, :last_fill_occupancy_county, 
       :authentication_token, :authenticated_at].map do |key| 
        raise "unknown param #{key}" unless parameters.has_key? key
        [key, parameters[key]]
      end
    param_string = mapped_params.map{|key, value| h={}; h[key] = value; h.to_param }.join("&")
    param_string += "&requestor_secret=#{ENV['requestor_secret']}"
    mac(param_string)
  end

  def signing_service_parameters_and_url(signature, service)
    server = "http" + (Rails.env == "development" ? "" : "s" ) + "://#{request.host_with_port}"
    parameters = { 
      message: {
        idea_id:                      signature.idea.id,
        idea_title:                   signature.idea.title,
        idea_date:                    signature.idea.updated_at,
        idea_mac:                     signature.idea_mac,
        citizen_id:                   current_citizen.id,
        accept_general:               signature.accept_general,
        accept_non_eu_server:         signature.accept_non_eu_server,
        accept_publicity:             signature.accept_publicity,
        accept_science:               signature.accept_science,
        service:                      service,
      },
      options: {
        success_url:                  server + signature_idea_signing_success_path(signature),
        failure_url:                  server + signature_idea_signing_failure_path(signature),
      },
      last_fill_first_names:        session["authenticated_firstnames"],
      last_fill_last_names:         session["authenticated_lastname"],
      last_fill_birth_date:         session["authenticated_birth_date"],              # FIXME, not set at the moment
      last_fill_occupancy_county:   session["authenticated_occupancy_county"],
      authentication_token:         session["authentication_token"],
      authenticated_at:             session["authenticated_at"],
    }
    parameters[:requestor_identifying_mac] = requestor_identifying_mac(parameters)
    base_url = {
      'production'  => "https://allekirjoitus.avoinministerio.fi/signatures", 
      'staging'     => "https://staging.allekirjoitus.avoinministerio.fi/signatures", 
      'development' => "http://localhost:3003/signatures", 
    }
    return parameters, base_url
  end

  def generate_signing_service_url(signature, service)
    parameters, base_url = signing_service_parameters_and_url(signature, service)
    p base_url[Rails.env]
    p parameters.to_query
    base_url[Rails.env] + "?" + parameters.to_query
  end

  def selected_free_service
    @signature = Signature.find_for(current_citizen, params[:id])
    puts "selected_free_service"
    p @signature
    if @signature
      services
      service = @services.find{|s| s[:name] == params[:service] } 
      if service and (not service[:min_fee])
        # user chose free service
        @signature.service = params[:service]
        @signature.save!
        p generate_signing_service_url(@signature, params[:service])
        redirect_to generate_signing_service_url(@signature, params[:service])
      else
        @error = "User chose non-free service"
      end
    else
      @error = "No signature found for current_citizen with #{params[:id]}"
    end
  end

  def services
    @services = [
      { vers:       "0001",
        rcvid:      "Elisa testi",
        idtype:     "12",
        name:       "Elisa Mobiilivarmenne testi",
        url:        "https://mtupaspreprod.elisa.fi/tunnistus/signature.cmd",
        min_fee:    nil,
      },
      { vers:       "0001",
        rcvid:      "Avoinministerio",
        idtype:     "12",
        name:       "Elisa Mobiilivarmenne",
        url:        "https://tunnistuspalvelu.elisa.fi/tunnistus/signature.cmd",
        min_fee:    nil,
      },

      { vers:       "0002",
        rcvid:      "AABTUPASID",
        idtype:     "02",
        name:       "Alandsbanken testi",
        url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do",
        min_fee:    0.50,
      },
      { vers:       "0002",
        rcvid:      "ELEKAMINNID",
        idtype:     "02",
        name:       "Alandsbanken",
        url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do",
        min_fee:    0.22,
      },
      { vers:       "0002",
        rcvid:      "KANNATUSTUPAS12",
        idtype:     "02",
        name:       "Tapiola testi",
        url:        "https://pankki.tapiola.fi/service/identify",
        min_fee:    nil,
      },
      { vers:       "0002",
        rcvid:      "KANNATUSTUPAS12",
        idtype:     "02",
        name:       "Tapiola",
        url:        "https://pankki.tapiola.fi/service/identify",
        min_fee:    nil,
      },

      { vers:       "0003",
        rcvid:      "024744039900",
        idtype:     "02",
        name:       "Sampo",
        url:        "https://verkkopankki.sampopankki.fi/SP/tupaha/TupahaApp",
        min_fee:    nil,
      },
    ]
  end

  def setup_services(stamp)
    @services = services
    @services.each do |service|
      set_defaults(service, stamp)
      set_mac(service)
      set_authenticated_urls(service, @signature.id)
    end
  end

  def set_defaults(service, stamp)
    service[:action_id] = "701"
    service[:langcode]  = "FI"
    service[:keyvers]   = "0001"
    service[:alg]       = "03"
    service[:stamp]     = stamp

    service[:mac]       = nil
  end

  def set_authenticated_urls(service, signature_id)
    server = "https://#{request.host_with_port}"
    Rails.logger.info "Server is #{server}"

    service_name = service[:name].gsub(/\s+/, "")
    service[:retlink]   = "#{server}/signatures/#{signature_id}/returning/#{service_name}"
    service[:canlink]   = "#{server}/signatures/#{signature_id}/cancelling/#{service_name}"
    service[:rejlink]   = "#{server}/signatures/#{signature_id}/rejecting/#{service_name}"
  end

  def set_mac(service)
    secret = service_secret(service[:name])
    keys = [:action_id, :vers, :rcvid, :langcode, :stamp, :idtype, :retlink, :canlink, :rejlink, :keyvers, :alg]
    vals = keys.map{|k| service[k] }
    string = vals.join("&") + "&" + secret + "&"
    service[:mac] = mac(string)
  end

  def service_secret(service)
    secret_key = "SECRET_" + service.gsub(/\s/, "")

    Rails.logger.info "Using key #{secret_key}"
    secret = ENV[secret_key] || ""

    # TODO: precalc the secret into environment variable, and remove this
    # special handling
    if service == "Alandsbanken" or service == "Tapiola"
      secret = secret_to_mac_string(secret)
      Rails.logger.info "Converting secret to #{secret}"
    end

    if secret == ""
      Rails.logger.error "No SECRET found for #{secret_key}"
    end

    secret
  end

  def secret_to_mac_string(secret)
    str = ""
    secret.split(//).each_slice(2){|a| str += a.join("").hex.chr}
    str
  end



  def sign
    # ERROR: Check that user has not signed already
    # TODO FIXME: check if user don't have any in-progress signatures
    # ie. cover case when user does not type in the url (when Sign button is not shown)
    @signature = Signature.create_with_citizen_and_idea(current_citizen, Idea.find(params[:id]))

    setup_services(@signature.stamp)

    # ERROR: check that there are enough acceptances
    fill_in_acceptances(@signature)
    @signature.idea_mac = idea_mac(@signature.idea)
    @error = "Couldn't save signature" unless @signature.save!

    respond_with @signature
  end

  def mac(string)
    Digest::SHA256.new.update(string).hexdigest.upcase
  end


  def valid_returning?(signature, service_name)
    values = %w(VERS TIMESTMP IDNBR STAMP CUSTNAME KEYVERS ALG CUSTID CUSTTYPE).map {|key| params["B02K_" + key]}
    string = values[0,9].join("&") + "&" + service_secret(service_name) + "&"
    params["B02K_MAC"] == mac(string)
  end

  def hetu_to_birth_date(hetu)
    date_part = hetu.gsub(/\-.+$/, "")
    year = date_part[4,2].to_i + hetu_separator_as_years(hetu)
    birth_date = Date.new(year, date_part[2,2].to_i, date_part[0,2].to_i)
  end

  # the latter part fixes -, + or A in HETU separator
  def hetu_separator_as_years(hetu)
    # convert 010203+1234 as years from 1800
    # convert 010203A1234 as years from 2000
    # otherwise it's year from 1900
    hetu[6,1] == "+" ? 1800 : hetu[6,1] == "A" ? 2000 : 1900
  end

  def within_timelimit?(signature)
    elapsed = (Time.now - signature.started)#*(60*60*24) # in seconds
    timelimit = (20*60)   # 20 mins
    within = elapsed <= timelimit
    Rails.logger.info "#{Time.now} - #{signature.started} = #{elapsed} which > #{timelimit}" unless within
    within
  end

  def repeated_returning?(signature)
    signature.state != "initial"
  end

  def returning
    @signature = Signature.find(params[:id])   # TODO: Add find for current_citizen
    if not @signature.citizen == current_citizen
      Rails.logger.info "Invalid user, not for the same user who initiated the signing"
      @error = "Invalid user"
    else
      service_name = params[:servicename]
      if not valid_returning?(@signature, service_name)
        Rails.logger.info "Invalid return"
        @signature.state = "invalid return"
        @error = "Invalid return"
      elsif not within_timelimit?(@signature)
        Rails.logger.info "not within timelimit"
        @signature.state = "too late"
        @error = "Not within timelimit"
      elsif repeated_returning?(@signature)
        Rails.logger.info "repeated returning"
        @signature.state = "repeated_returning"
        @error = "Repeated returning"
      elsif check_previously_signed(current_citizen, @signature.idea_id)
        @error = "Aiemmin allekirjoitettu"
      else
        # all success!
        Rails.logger.info "All success, authentication ok, storing into session"
        @error = nil
        birth_date = hetu_to_birth_date(params["B02K_CUSTID"])
        firstnames, lastname = guess_names(params["B02K_CUSTNAME"], @signature.firstnames, @signature.lastname)
        @signature.state = "authenticated"
        @signature.update_attributes(signing_date: today_date(), birth_date: birth_date, firstnames: firstnames, lastname: lastname)
        session["authenticated_at"]         = DateTime.now
        session["authenticated_birth_date"] = birth_date
        session["authenticated_approvals"]  = @signature.id
      end
    end
    @signature.save
    respond_with @signature
  end

  def cancelling
    @signature = Signature.find(params[:id])   # TODO: Add find for current_citizen
    if not @signature.citizen == current_citizen
      Rails.logger.info "Invalid user, not for the same user who initiated the signing"
      @error = "Invalid user"
    else
      service_name = params[:servicename]
      Rails.logger.info "Cancelling"
      @signature.state = "cancelled"
      @signature.save
      @error = "Cancelling authentication"
    end
    respond_with @signature
  end

  def rejecting
    @signature = Signature.find(params[:id])   # TODO: Add find for current_citizen
    if not @signature.citizen == current_citizen
      Rails.logger.info "Invalid user, not for the same user who initiated the signing"
      @error = "Invalid user"
    else
      service_name = params[:servicename]
      Rails.logger.info "Rejecting"
      @signature.state = "rejected"
      @signature.save
      @error = "Rejecting authentication"
    end
    respond_with @signature
  end

  def finalize_signing
    signature = finalize_signing_by_checking
    respond_with signature
  end

  def finalize_signing_by_checking
    #    @signature = current_citizen.signatures.where(state: 'authenticated').find(params[:id])
    @signature = Signature.where(state: 'authenticated').find(params[:id])
    if @signature and @signature.citizen == current_citizen and @signature.state == "authenticated"   # TODO: and duration since last authentication less that threshold
      # validate input before storing
      if justNameCharacters(params["signature"]["firstnames"]) and 
          justNameCharacters(params["signature"]["lastname"])   and 
          municipalities.include? params["signature"]["occupancy_county"] and
          params["signature"]["vow"] == "1"
        unless check_previously_signed(current_citizen, @signature.idea_id)

        @signature.firstnames       = params["signature"]["firstnames"]
        @signature.lastname         = params["signature"]["lastname"]
        @signature.occupancy_county = params["signature"]["occupancy_county"]
        @signature.vow              = params["signature"]["vow"]
        @signature.state            = "signed"
        @signature.signing_date     = today_date
        @error = "Couldn't save signature" unless @signature.save

        session["authenticated_firstnames"]       = @signature.firstnames
        session["authenticated_lastname"]         = @signature.lastname
        session["authenticated_occupancy_county"] = @signature.occupancy_county

        # show only proposals that haven't yet been signed by current_citizen
        signatures = Arel::Table.new(:signatures)
        already_signed = Signature.where(signatures[:state].eq('signed'), signatures[:citizen].eq(current_citizen.id)).find(:all, select: "idea_id").map{|s| s.idea_id}.uniq
        ideas = Arel::Table.new(:ideas)
        proposals_not_in_already_signed = (ideas[:state].eq('proposal')).and(ideas[:id].not_in(already_signed))
        @initiatives = Idea.where(proposals_not_in_already_signed).order("vote_for_count DESC").limit(5).all
        
        else
          @error = "Aiemmin allekirjoitettu"
        end
      else
        @error = "Invalid parameters"
      end
    else
      @error = "Trying to alter other citizen or signature with other than authenticated state"
    end
    @signature
  end


  def shortcut_fillin
    if shortcut_session_valid?
      if not check_previously_signed(current_citizen, params[:id])
        @signature = Signature.create_with_citizen_and_idea(current_citizen, Idea.find(params[:id]))

        @previous_signature = Signature.find(session["authenticated_approvals"])
        @signature.accept_general       = @previous_signature.accept_general
        @signature.accept_non_eu_server = @previous_signature.accept_non_eu_server
        @signature.accept_publicity     = @previous_signature.accept_publicity
        @signature.accept_science       = @previous_signature.accept_science

        # Consider: would it be better to use @previous_signature instead of
        # session to pick up all of these
        @signature.signing_date         = today_date()
        @signature.birth_date           = session["authenticated_birth_date"]
        @signature.firstnames           = session["authenticated_firstnames"]
        @signature.lastname             = session["authenticated_lastname"]
        @signature.occupancy_county     = session["authenticated_occupancy_county"]
        @signature.idea_mac             = idea_mac(@signature.idea)
        @signature.state                = "authenticated"
        @error = "Couldn't save signature" unless @signature.save
      else
        @error = "Aiemmin allekirjoitettu"
      end
      respond_with @signature
    else
      redirect_to signature_idea_introduction_path(params[:id])
    end
  end

  def shortcut_finalize_signing
    if shortcut_session_valid?
      if not check_previously_signed(current_citizen, params[:id])
        @signature = finalize_signing_by_checking
        fill_in_acceptances(@signature)
      else
        # @signature.idea is referenced in the view,
        # so @signature mustn't be nil
        @signature = Signature.where(state: 'authenticated').find(params[:id])
        @error = "Previously signed"
      end
      render :finalize_signing
    else
      redirect_to signature_idea_introduction_path(params[:id])
    end
  end

  def check_previously_signed(citizen, idea_id)
    if ENV["ALLOW_SIGNING_MULTIPLE_TIMES"]
      false
    else
      completed_signature = Signature.where(state: "signed", citizen_id: citizen.id, idea_id: idea_id).first
      if completed_signature
        true
      else
        false
      end
    end
  end

  def idea_mac(idea)
    mac(idea.title + idea.body + idea.updated_at.to_s)
  end
  
  def check_if_idea_can_be_signed
    idea = Idea.find(params[:id])
    if !idea.can_be_signed?
      Rails.logger.info "can't be signed"
      @error = "Can't be signed"
    end
  end

  def signing_success
    validate_service_provider!

    #    @signature = current_citizen.signatures.where(state: 'authenticated').find(params[:id])
    @signature = Signature.where(state: 'initial').find(params[:id])
    if @signature and @signature.citizen == current_citizen and @signature.state == "initial"   # TODO: and duration since last authentication less that threshold
      # validate input before storing
      if justNameCharacters(params["first_names"]) and 
          justNameCharacters(params["last_name"])   and 
          municipalities.include? params["occupancy_county"]
        if $ALLOW_SIGNING_MULTIPLE_TIMES or not check_previously_signed(current_citizen, params[:id])
          # TODO: these updates should be removed, and only be marked that user has signed the idea
          @signature.firstnames       = params["first_names"]
          @signature.lastname         = params["last_name"]
          @signature.occupancy_county = params["occupancy_county"]
          @signature.birth_date       = params["birth_date"]
          @signature.state            = "signed"
          @signature.signing_date     = today_date
          @error = "Couldn't save signature" unless @signature.save

          session["authenticated_firstnames"]       = @signature.firstnames
          session["authenticated_lastname"]         = @signature.lastname
          session["authenticated_occupancy_county"] = @signature.occupancy_county
          session["authenticated_birth_date"]       = @signature.birth_date
          session["authenticated_at"]               = params["authenticated_at"]
          session["authentication_token"]           = params["authentication_token"]

          # show only proposals that haven't yet been signed by current_citizen
          signatures = Arel::Table.new(:signatures)
          already_signed = Signature.where(signatures[:state].eq('signed'), signatures[:citizen].eq(current_citizen.id)).find(:all, select: "idea_id").map{|s| s.idea_id}.uniq
          ideas = Arel::Table.new(:ideas)
          proposals_not_in_already_signed = (ideas[:state].eq('proposal')).and(ideas[:id].not_in(already_signed))
          @initiatives = Idea.where(proposals_not_in_already_signed).order("vote_for_count DESC").limit(5).all
        else
          @error = "Aiemmin allekirjoitettu" if not $ALLOW_SIGNING_MULTIPLE_TIMES
        end
      else
        @error = "Invalid parameters"
      end
    else
      @error = "Trying to alter other citizen or signature with other than authenticated state"
    end
  end

  def signing_failure
    @signature = Signature.where(state: 'initial').find(params[:id])
    if @signature and @signature.citizen == current_citizen and @signature.state == "initial" 
      @error = "Tunnistaminen tai allekirjoittaminen epäonnistui"
    else
      @error = "Allekirjoitusta ei ole, se ei ole nykyisen käyttäjän tai se on jo hoidettu pidemmälle"
    end
  end

  require 'uri'
  def service_provider_params_as_string(params)
    parameters_as_string = [:first_names, :last_name, :occupancy_county, :authenticated_at, :birth_date, :authentication_token].map {|key| h={}; h[key]=params[key]; h.to_param}.join("&")
    u = URI(request.fullpath)
    request.protocol + request.host_with_port + u.path + "?" + parameters_as_string
  end

  def validate_service_provider!
    param_string = service_provider_params_as_string(params) + "&requestor_secret=#{ENV['requestor_secret']}"
    p param_string
    p params
    p mac(param_string)
    raise Exception.new unless params[:service_provider_identifying_mac] == mac(param_string)
  end


end
