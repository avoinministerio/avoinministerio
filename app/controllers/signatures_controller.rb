# #encoding: UTF-8

require 'date'

require 'signatures_controller_helpers'

class SignaturesController < ApplicationController

  include SignaturesControllerHelpers

  before_filter :authenticate_citizen!
  before_filter :check_if_idea_can_be_signed, :except => [:returning,
    :cancelling,
    :rejecting,
    :finalize_signing,
    :shortcut_finalize_signing]

  respond_to :html

  def introduction
  end

  def approval
  end

  def fill_in_acceptances(signature)
    signature.accept_general       = params[:accept_general]
    signature.accept_non_eu_server = params[:accept_non_eu_server]
    signature.accept_publicity     = params[:publicity]
    signature.accept_science       = params[:accept_science]
  end

  def sign
    # TODO FIXME: check if user don't have any in-progress signatures ie. cover
    # case when user does not type in the url (when Sign button is not shown)
    @signature = Signature.create_with_citizen_and_idea(current_citizen, Idea.find(params[:id]))

    if @signature
      # ERROR: check that there are enough acceptances
      fill_in_acceptances(@signature)
      @signature.idea_mac = idea_mac(@signature.idea)
      unless @signature.save
        @error = "Couldn't save signature"
        redirect_to signature_idea_introduction_path(params[:id]) and return
      end

      @services = [
        { vers:       "0001",
          rcvid:      "Elisa testi",
          idtype:     "12",
          name:       "Elisa Mobiilivarmenne testi",
          url:        "https://mtupaspreprod.elisa.fi/tunnistus/signature.cmd",
        },
        { vers:       "0001",
          rcvid:      "Avoinministerio",
          idtype:     "12",
          name:       "Elisa Mobiilivarmenne",
          url:        "https://tunnistuspalvelu.elisa.fi/tunnistus/signature.cmd",
        },

        { vers:       "0002",
          rcvid:      "AABTUPASID",
          idtype:     "02",
          name:       "Alandsbanken testi",
          url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do",
        },
        { vers:       "0002",
          rcvid:      "ELEKAMINNID",
          idtype:     "02",
          name:       "Alandsbanken",
          url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do",
        },
        { vers:       "0002",
          rcvid:      "KANNATUSTUPAS12",
          idtype:     "02",
          name:       "Tapiola testi",
          url:        "https://pankki.tapiola.fi/service/identify",
        },
        { vers:       "0002",
          rcvid:      "KANNATUSTUPAS12",
          idtype:     "02",
          name:       "Tapiola",
          url:        "https://pankki.tapiola.fi/service/identify",
        },

        { vers:       "0003",
          rcvid:      "024744039900",
          idtype:     "02",
          name:       "Sampo",
          url:        "https://verkkopankki.sampopankki.fi/SP/tupaha/TupahaApp",
        },
      ]

      @services.each do |service|
        set_defaults(service)
        set_mac(service)
      end
      
      respond_with @signature
    
    else
      @error = "Aiemmin allekirjoitettu"
      redirect_to idea_path(params[:id])
    end
  end

  def set_defaults(service)
    service[:action_id] = "701"
    service[:langcode]  = "FI"
    service[:keyvers]   = "0001"
    service[:alg]       = "03"
    service[:stamp]     = @signature.stamp

    service[:mac]       = nil

    server = "https://#{request.host_with_port}"
    Rails.logger.info "Server is #{server}"

    service_name = service[:name].gsub(/\s+/, "")
    service[:retlink]   = "#{server}/signatures/#{@signature.id}/returning/#{service_name}"
    service[:canlink]   = "#{server}/signatures/#{@signature.id}/cancelling/#{service_name}"
    service[:rejlink]   = "#{server}/signatures/#{@signature.id}/rejecting/#{service_name}"
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
    if check_shortcut_session_validity 
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
    if check_shortcut_session_validity 
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
    if ENV["Allow_Signing_Multiple_Times"]
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

end
