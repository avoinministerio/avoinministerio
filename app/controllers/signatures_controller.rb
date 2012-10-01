# #encoding: UTF-8

require 'date'

require 'signatures_controller_helpers'

$ALLOW_SIGNING_MULTIPLE_TIMES = ENV['ALLOW_SIGNING_MULTIPLE_TIMES']

class SignaturesController < ApplicationController

  include SignaturesControllerHelpers

  before_filter :authenticate_citizen!,       :except => [:successful_authentication]
  before_filter :check_if_idea_can_be_signed, :except => [:selected_free_service,
                                                          :selected_costly_service,
                                                          :paid_returning,
                                                          :paid_canceling,
                                                          :paid_rejecting,
                                                          :shortcutting_to_signing,
                                                          :successful_authentication,

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
    signature.accept_general       = params[:accept_general]        || session["authenticated_accept_general"]
    signature.accept_non_eu_server = params[:accept_non_eu_server]  || session["authenticated_accept_non_eu_server"]
    signature.accept_publicity     = params[:publicity]             || session["authenticated_accept_publicity"]
    signature.accept_science       = params[:accept_science]        || session["authenticated_accept_science"]
    signature.accept_science = false if signature.accept_science == ''
  end

  def service_selection
#    @signature = Signature.create_with_citizen_and_idea(current_citizen, Idea.find(params[:id]))
    @idea = Idea.find(params[:id])

    if not $ALLOW_SIGNING_MULTIPLE_TIMES and check_previously_signed(current_citizen, params[:id])
      @error = "Kannatusilmoitus idealle on jätetty jo aiemmin"
      return
    end

    if check_previously_signed(current_citizen, params[:id])
      @info = "Idealle on jätetty kannatusilmoitus jo aiemmin, mutta uudelleenjättäminen on sallittua nyt vielä"
    end
    @signature = Signature.new()
    @signature.idea                   = @idea
    @signature.idea_title             = @idea.title
    @signature.idea_date              = @idea.updated_at
    @signature.citizen                = current_citizen
    @signature.firstnames             = session["authenticated_firstnames"] || current_citizen.first_names
    @signature.lastname               = session["authenticated_lastname"] || current_citizen.last_name
    @signature.state                  = "initial"
    @signature.stamp                  = DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s
    @signature.started                = Time.now
    @signature.occupancy_county       = session["authenticated_occupancy_county"] || ""
    @signature.service                = nil

    # ERROR: check that there are enough acceptances
    fill_in_acceptances(@signature)
    puts "Is signature.valid?"
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

    tupas_services
    @parameters_and_urls = {}
    @tupas_services.each {|service| @parameters_and_urls[service[:name]] = signing_service_parameters_and_url(@signature, service)}

    setup_payment_services(@signature)
  end

  def paid_returning
    validate_payment_service_provider(params)
    # add payment to user account
    payment_services("", -1)  # parameters don't matter, but we want to get fees

    # FIXME, we should make a MAC and validate it to ensure tamper-free id in params 
    # as some banks don't calc MAC over urls
    signature = Signature.find(params[:id])   

    payment_service = @payment_services.find {|ps| ps[:name] == params[:servicename]}
    fee = payment_service[:fee]
    current_citizen.deposit_money(BigDecimal.new(fee), "paid signature #{signature.id}")

    # save here so that the transaction gets saved anyway
    signature.service = params[:servicename]
    raise "Can't assign service" unless signature.save

    # forward to signing service

    p generate_signing_service_url(signature, params[:servicename])
    redirect_to generate_signing_service_url(signature, params[:servicename])
  end
  def paid_canceling
    raise "at paid canceling"
  end
  def paid_rejecting
    raise "at paid rejecting"
  end

  def requestor_secret
#    config.signature_secret || "abc"   # FIXME: this didn't work even staging either
    ENV['SIGNATURE_SECRET'] || "abc"
  end

  def requestor_identifying_mac(parameters)
    signing_api_parameters_options = {
      "1.0" => [:idea_id, :idea_title, :idea_date, :idea_mac, 
       :citizen_id, 
       :accept_general, :accept_non_eu_server, :accept_publicity, :accept_science,
       :service
      ],
      "2.0" => [:idea_id, :idea_title, :idea_date, :idea_mac, 
       :citizen_id, 
       :accept_general, :accept_non_eu_server, :accept_publicity, :accept_science,
       :service, :success_auth_url
      ]
    }
    signing_api_parameters = signing_api_parameters_options[ENV['SIGNING_API_VERSION']]

    mapped_params = 
      signing_api_parameters.map do |key| 
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
    param_string += "&requestor_secret=#{requestor_secret()}"
    if ENV['DEBUG_MACS']
      Rails.logger.info "DEBUG_MACS"
      Rails.logger.info requestor_secret
      Rails.logger.info config.signature_secret
      Rails.logger.info param_string
      Rails.logger.info mac(param_string) 
    end
    mac(param_string)
  end

  def signing_service_parameters_and_url(signature, service)
    parameters = { 
      message: {
        idea_id:                      signature.idea.id,
        idea_title:                   signature.idea.title,
        idea_date:                    signature.idea.collecting_start_date,
        idea_mac:                     idea_mac(signature.idea),
        citizen_id:                   current_citizen.id,
        accept_general:               signature.accept_general,
        accept_non_eu_server:         signature.accept_non_eu_server,
        accept_publicity:             signature.accept_publicity,
        accept_science:               signature.accept_science,
        service:                      service,
      },
      options: {
        success_url:                  server_as_url + signature_idea_signing_success_path(signature),
        failure_url:                  server_as_url + signature_idea_signing_failure_path(signature),
      },
      last_fill_first_names:        session["authenticated_firstnames"],
      last_fill_last_names:         session["authenticated_lastname"],
      last_fill_birth_date:         session["authenticated_birth_date"],              # FIXME, not set at the moment
      last_fill_occupancy_county:   session["authenticated_occupancy_county"],
      authentication_token:         session["authentication_token"],
      authenticated_at:             session["authenticated_at"],
    }
    if ENV['SIGNING_API_VERSION'] == "2.0"
      parameters[:message][:success_auth_url] = generate_success_auth_url(@signature)
    end
    parameters[:requestor_identifying_mac] = requestor_identifying_mac(parameters)
    base_url = {
      'production'  => "https://allekirjoitus.avoinministerio.fi/signatures", 
      'staging'     => "https://staging.allekirjoitus.avoinministerio.fi/signatures", 
      'development' => "http://localhost:3003/signatures", 
    }
    return parameters, base_url
  end

  def server_as_url
    server = "http" + (Rails.env == "development" ? "" : "s" ) + "://#{request.host_with_port}"
  end

  def generate_success_auth_url(signature)
    security_token = mac(service_provider_params_as_string({id: @signature.id}, [:id])) 
    server_as_url + signature_idea_successful_authentication_path(signature) + "?" + {security_token: security_token}.to_query
  end

  def generate_failure_url(signature)
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
      tupas_services
      service = @tupas_services.find{|s| s[:name] == params[:service] } 
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

  def selected_costly_service
    @signature = Signature.find_for(current_citizen, params[:id])
    puts "selected_free_service"
    p @signature
    if @signature
      tupas_services
      service = @tupas_services.find{|s| s[:name] == params[:service] } 
      if service and service[:min_fee] and current_citizen.saldo >= service[:min_fee].to_f
        @signature.service = params[:service]
        @signature.save!
        p generate_signing_service_url(@signature, params[:service])
        redirect_to generate_signing_service_url(@signature, params[:service])
      else
        @error = "User chose costly service without enough saldo (or free service)"
      end
    else
      @error = "No signature found for current_citizen with #{params[:id]}"
    end

  end

  def shortcutting_to_signing
    @signature = Signature.find_for(current_citizen, params[:id])

    if shortcut_session_valid?
      @signature.service = "shortcut"
      @signature.save!
      p generate_signing_service_url(@signature, params[:service])
      redirect_to generate_signing_service_url(@signature, params[:service])
    else
      redirect_to :back
    end
  end

  def tupas_services
    @tupas_services = [
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
        min_fee:    0.28,
      },
      { vers:       "0002",
        rcvid:      "ELEKAMINNID",
        idtype:     "02",
        name:       "Alandsbanken",
        url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do",
        min_fee:    0.28,
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
        min_fee:    0.37,
      },

      { vers:       "0002",
        rcvid:      "AVOIN MINISTERIÖ REK YHD RY",
        idtype:     "02",
        name:       "S-Pankki",
        url:        "https://online.s-pankki.fi/service/identify",
        min_fee:    nil,
      },

      { vers:       "0002",
        rcvid:      "0024744039",
        idtype:     "02",
        name:       "Handelsbanken",
        url:        "https://tunnistepalvelu.samlink.fi/TupasTunnistus/SHBtupas.html",
        min_fee:    nil,
      },

      { vers:       "0002",
        rcvid:      "0024744039",
        idtype:     "02",
        name:       "Aktia",
        url:        "https://tunnistepalvelu.samlink.fi/TupasTunnistus/TupasServlet",
        min_fee:    0.32,
      },

      { vers:       "0002",
        rcvid:      "1028275M",
        idtype:     "02",
        name:       "Nordea",
        url:        "https://solo3.nordea.fi/cgi-bin/SOLO3011",
        min_fee:    1.00,
      },

      { vers:       "0003",
        rcvid:      "TUAVOINMINISTER",
        idtype:     "02",
        name:       "Osuuspankki",
        url:        "https://kultaraha.op.fi/cgi-bin/krcgi",
        min_fee:    0.62,
      },
    ]
    ENV['DISABLE_TUPAS_SERVICES'].split(/,/).each do |disable_tupas_service|
      @tupas_services.delete_if do |tupas_service| 
        tupas_service[:name].gsub(/[ \-]/, "_") == disable_tupas_service
      end
    end
    @tupas_services
  end

  def setup_tupas_services(stamp)
    @tupas_services = tupas_services
    @tupas_services.each do |service|
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

    service_name = service[:name].gsub(/[\s\-]+/, "")
    service[:retlink]   = "#{server}/signatures/#{signature_id}/returning/#{service_name}"
    service[:canlink]   = "#{server}/signatures/#{signature_id}/cancelling/#{service_name}"
    service[:rejlink]   = "#{server}/signatures/#{signature_id}/rejecting/#{service_name}"
  end

  def set_mac(service)
    secret = service_secret(service[:name], "tupas")
    keys = [:action_id, :vers, :rcvid, :langcode, :stamp, :idtype, :retlink, :canlink, :rejlink, :keyvers, :alg]
    vals = keys.map{|k| service[k] }
    string = vals.join("&") + "&" + secret + "&"
    service[:mac] = mac(string)
  end

  def service_secret(service, system)
    secret_key = "SECRET_#{system}_" + service.gsub(/[\s\-]/, "")

    Rails.logger.info "Using key #{secret_key}"
    secret = ENV[secret_key] || ""

    # TODO: precalc the secret into environment variable, and remove this
    # special handling
#    if service == "Alandsbanken" or service == "Tapiola"
#      secret = secret_to_mac_string(secret)
#      Rails.logger.info "Converting secret to #{secret}"
#    end

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

  def setup_payment_services(signature)
    payment_services(signature.stamp, signature.id)
    @payment_services.each do |payment_service| 
      set_payment_mac(payment_service)
    end
  end

  def payment_services(stamp, signature_id)
    server = "http" + (Rails.env == "development" ? "" : "s" ) + "://#{request.host_with_port}"

    @payment_services = [
      { name:               "Alandsbanken",
#        url:                "https://online.alandsbanken.fi/service/paybutton",
        url:                "https://online.alandsbanken.fi/aab/ebank/auth/initLogin.do?BV_UseBVCookie=no",
        fee:                "0.28",
        AAB_VERSION:        "0002",
        AAB_STAMP:          stamp[0,15],
        AAB_RCV_ID:         "EBETAMIN",
#        AAB_RCV_ACCOUNT:    "660100-1870443",
        AAB_RCV_ACCOUNT:    "660100-01116755",
#        AAB_RCV_NAME:       "Avoin ministeriö rekisteröity yhdistys ry",
        AAB_RCV_NAME:       "Avoin minist.ry",
        AAB_LANGUAGE:       "1",
        AAB_AMOUNT:         "0,28",
        AAB_REF:            ref_calculation(123456),
        AAB_DATE:           "EXPRESS",
        AAB_MSG:            "Sahkoinen kannatusilmoitus",
        AAB_RETURN:         "#{server}/signatures/#{signature_id}/paid_returning/Alandsbanken",
        AAB_CANCEL:         "#{server}/signatures/#{signature_id}/paid_canceling/Alandsbanken",
        AAB_REJECT:         "#{server}/signatures/#{signature_id}/paid_rejecting/Alandsbanken",
        AAB_CONFIRM:        "YES",
        AAB_KEYVERS:        "0001",
        AAB_CUR:            "EUR",
        BV_UseBVCookie:     "no",
      },
      { name:               "Sampo",
        url:                "https://verkkopankki.sampopankki.fi/SP/vemaha/VemahaApp",
        fee:                "0.37",
        SUMMA:              "0,37",
        VIITE:              ref_calculation(123456),  # FIXME stamp into here
        KNRO:               "024744039801",
        VALUUTTA:           "EUR",
        VERSIO:             "3",
        OKURL:              "#{server}/signatures/#{signature_id}/paid_returning/Sampo",
        VIRHEURL:           "#{server}/signatures/#{signature_id}/paid_rejecting/Sampo",
        lng:                1,
      },
      { name:               "Nordea",
        url:                "https://solo3.nordea.fi/cgi-bin/SOLOPM01",
        fee:                "1.00",
        SOLOPMT_VERSION:    "0003",
        SOLOPMT_STAMP:      stamp,
        SOLOPMT_RCV_ID:     "1028275M",
#        SOLOPMT_RCV_ACCOUNT:"FI2812283000021780",
#        SOLOPMT_RCV_NAME:   "",
        SOLOPMT_LANGUAGE:   "1",
        SOLOPMT_AMOUNT:     "1,00",
        SOLOPMT_REF:        ref_calculation(123456),
        SOLOPMT_DATE:       "EXPRESS",
        SOLOPMT_MSG:        "Sahkoinen kannatusilmoitus",
        SOLOPMT_RETURN:     "#{server}/signatures/#{signature_id}/paid_returning/Nordea",
        SOLOPMT_CANCEL:     "#{server}/signatures/#{signature_id}/paid_canceling/Nordea",
        SOLOPMT_REJECT:     "#{server}/signatures/#{signature_id}/paid_rejecting/Nordea",
        SOLOPMT_CONFIRM:    "YES",
        SOLOPMT_KEYVERS:    "0001",
        SOLOPMT_CUR:        "EUR",
      },
      { name:               "Osuuspankki",
        url:                "https://kultaraha.op.fi/cgi-bin/krcgi",
        fee:                "0.62",
        action_id:          "701",
        VERSIO:             "1",
        MAKSUTUNNUS:        stamp,
        MYYJA:              "AVOINMINISTERIO",
        SUMMA:              "0,62",
        VIITE:              ref_calculation(123456),
        VIEST1:             "Sahkoinen kannatusilmoitus",
        "TARKISTE-VERSIO"=> "1",
        "PALUU-LINKKI"=>    "#{server}/signatures/#{signature_id}/paid_returning/Osuuspankki",
        PERUUTUSLINKKI:     "#{server}/signatures/#{signature_id}/paid_rejecting/Osuuspankki",
        VAHVISTUS:          "K",
        VALUUTTALAJI:       "EUR",
      },
      { name:               "Aktia",
        url:                "https://verkkomaksu.inetpankki.samlink.fi/vm/login.html",
        fee:                "0.32",
        NET_VERSION:        "002",
        NET_STAMP:          stamp,
        NET_SELLER_ID:      "0024744039000",
        NET_AMOUNT:         "0,32",
        NET_REF:            ref_calculation(123456),
        NET_DATE:           "EXPRESS",
        NET_MSG:            "Sahkoinen kannatusilmoitus",
        NET_RETURN:         "#{server}/signatures/#{signature_id}/paid_returning/Aktia",
        NET_CANCEL:         "#{server}/signatures/#{signature_id}/paid_canceling/Aktia",
        NET_REJECT:         "#{server}/signatures/#{signature_id}/paid_rejecting/Aktia",
        NET_CONFIRM:        "YES",
        NET_CUR:            "EUR",
      },
    ]

    ENV['DISABLE_PAYMENT_SERVICES'].split(/,/).each do |disable_payment_service|
      @payment_services.delete_if do |payment_service| 
        payment_service[:name].gsub(/[ \-]/, "_") == disable_payment_service
      end
    end
    @payment_services
  end

  def set_payment_mac(payment_service)
    fields = {
      "Alandsbanken" => {
        mac_over:   [:AAB_VERSION, :AAB_STAMP, :AAB_RCV_ID, :AAB_AMOUNT, :AAB_REF, :AAB_DATE, :AAB_CUR, :secret__],
        mac_field:  :AAB_MAC,
        separator:  "&",
      },
      "Sampo" => {
        mac_over:   [:secret__, :SUMMA, :VIITE, :KNRO, :VERSIO, :VALUUTTA, :OKURL, :VIRHEURL],
        mac_field:  :TARKISTE,
        separator:  "",
      },
      "Nordea" => {
        mac_over:   [:SOLOPMT_VERSION, :SOLOPMT_STAMP, :SOLOPMT_RCV_ID, :SOLOPMT_AMOUNT, :SOLOPMT_REF, :SOLOPMT_DATE, :SOLOPMT_CUR, :secret__],
        mac_field:  :SOLOPMT_MAC,
        separator:  "&",
      },
      "Osuuspankki" => {
        mac_over:   [:VERSIO, :MAKSUTUNNUS, :MYYJA, :SUMMA, :VIITE, :VIEST1, :VIEST2, :VALUUTTALAJI, "TARKISTE-VERSIO", :secret__],
        mac_field:  :TARKISTE,
        separator:  "",
      },
      "Aktia" => {
        mac_over:   [:NET_VERSION, :NET_STAMP, :NET_SELLER_ID, :NET_AMOUNT, :NET_REF, :NET_DATE, :NET_CUR, :NET_RETURN, :NET_CANCEL, :NET_REJECT, :secret__],
        mac_field:  :NET_MAC,
        separator:  "&",
      },
    }
    payment_provider_fields = fields[payment_service[:name]]
    mac_over  = payment_provider_fields[:mac_over ]
    mac_field = payment_provider_fields[:mac_field]
    separator = payment_provider_fields[:separator]

    # place the secret temporarily into the hash
    payment_service[:secret__] = service_secret(payment_service[:name], "payment")

    values =  mac_over.map do |key| 
      value = payment_service[key]
      value = value.to_s.gsub(/\s+$/,"") if payment_service[:name] == "Osuuspankki"  # spec requires removing end blanks
      value
    end
    payment_service.delete :secret__   # remove temporary key

    string_for_mac = values.join(separator) + separator
    puts "String for mac: #{string_for_mac}"
    mac = Digest::MD5.new.update(string_for_mac).hexdigest.upcase
    puts "MAC:            #{mac}"
    payment_service[mac_field] = mac
  end

  def ref_calculation(reference)
    number = reference
    checksum = 0
    digit_index = 0
    while number > 0
      last_digit, number = (number % 10), number / 10
      checksum += last_digit * [7, 3, 1][digit_index%3]
      digit_index += 1
    end
    reference * 10 + (-checksum % 10)
  end




  def sign
    # ERROR: Check that user has not signed already
    # TODO FIXME: check if user don't have any in-progress signatures
    # ie. cover case when user does not type in the url (when Sign button is not shown)
    @signature = Signature.create_with_citizen_and_idea(current_citizen, Idea.find(params[:id]))

    setup_tupas_services(@signature.stamp)

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
    string = values[0,9].join("&") + "&" + service_secret(service_name, "tupas") + "&"
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
    mac(idea.title + idea.summary + idea.body + idea.updated_at.to_s)
  end
  
  def check_if_idea_can_be_signed
    idea = Idea.find(params[:id])
    if !idea.can_be_signed?
      Rails.logger.info "can't be signed"
      @error = "Can't be signed"
    end
  end

  def pay_service_fee(signature)
    payment_services("", -1)  # parameters don't matter, but we want to get fees
    payment_service = @payment_services.find {|ps| ps[:name] == signature.service}
    Rails.logger.info "### In pay_service_fee"
    Rails.logger.info payment_service.inspect
    if payment_service
      fee = payment_service[:fee]
      Rails.logger.info fee
      if fee and fee.to_f > 0.0
        Rails.logger.info current_citizen.saldo
        current_citizen.deposit_money(-BigDecimal.new(fee), "used at signature succeeded #{signature.id}")
        Rails.logger.info current_citizen.saldo
      end
    end
  end

  def signing_success
    validate_service_provider!

    #    @signature = current_citizen.signatures.where(state: 'authenticated').find(params[:id])
    @signature = Signature.where(state: 'initial').find(params[:id])
    if @signature
      pay_service_fee(@signature)

      if @signature.citizen == current_citizen and @signature.state == "initial"   # TODO: and duration since last authentication less that threshold

        # FIXME: find if intermediate call to successful_authentication has been done, if make the transaction now

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
            session["authenticated_accept_general"]   = @signature.accept_general
            session["authenticated_accept_non_eu_server"] = @signature.accept_non_eu_server
            session["authenticated_accept_publicity"] = @signature.accept_publicity
            session["authenticated_accept_science"]   = @signature.accept_science

            # show only proposals that haven't yet been signed by current_citizen
            signatures = Arel::Table.new(:signatures)
            already_signed = Signature.where(signatures[:state].eq('signed'), signatures[:citizen].eq(current_citizen.id)).find(:all, select: "idea_id").map{|s| s.idea_id}.uniq
            ideas = Arel::Table.new(:ideas)
            proposals_not_in_already_signed = (ideas[:state].eq('proposal')).and(ideas[:id].not_in(already_signed))
            proposals_collectible = (ideas[:collecting_in_service].eq(true)).and(ideas[:collecting_started].eq(true)).and(ideas[:collecting_ended].eq(false))
            unsigned_collectible_proposals = proposals_not_in_already_signed.and(proposals_collectible)
            @initiatives = Idea.where(unsigned_collectible_proposals).order("vote_for_count DESC").limit(5).all
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
  end

  def signing_failure
    @signature = Signature.where(state: 'initial').find(params[:id])
    if @signature and @signature.citizen == current_citizen and @signature.state == "initial" 
      @error = "Tunnistaminen tai allekirjoittaminen epäonnistui"
    else
      @error = "Allekirjoitusta ei ole, se ei ole nykyisen käyttäjän tai se on jo hoidettu pidemmälle"
    end
  end

  def service_provider_params_as_string(params, fields)
    parameters_as_string = fields.map {|key| h={}; h[key]=params[key]; h.to_param}.join("&")
  end

  def validate_security_token!(params, fields, security_token)
    param_string = service_provider_params_as_string(params, fields) + "&requestor_secret=#{requestor_secret()}"
    
    require 'uri'
    u = URI(request.fullpath)
    param_string = request.protocol + request.host_with_port + u.path + "?" + param_string
    
    p param_string
    p params
    p mac(param_string)
    raise Exception.new unless params[security_token] == mac(param_string)
  end

  def validate_service_provider!
    validate_security_token!(params, [:first_names, :last_name, :occupancy_county, :authenticated_at, :birth_date, :authentication_token], :service_provider_identifying_mac)
  end

  def validate_payment_service_provider(params)
    fields = {
      "Alandsbanken" => {
        return_mac_over: ["AAB-RETURN-VERSION", "AAB-RETURN-STAMP", "AAB-RETURN-REF", "AAB-RETURN-PAID", :secret__],
        return_mac:       "AAB-RETURN-MAC",
        separator:        "&",
      },
      "Sampo" => {
        return_mac_over: [:secret__, "VIITE", "SUMMA", "STATUS", "KNRO", "VERSIO", "VALUUTTA"],
        return_mac:       "TARKISTE",
        separator:        "",
      },
      "Nordea" => {
        return_mac_over: ["SOLOPMT_RETURN_VERSION", "SOLOPMT_RETURN_STAMP", "SOLOPMT_RETURN_REF", "SOLOPMT_RETURN_PAID", :secret__],
        return_mac:       "SOLOPMT_RETURN_MAC",
        separator:        "&",
      },
      "Osuuspankki" => {
        return_mac_over: ["VERSIO", "MAKSUTUNNUS", "VIITE", "ARKISTOINTITUNNUS", "TARKISTE-VERSIO", :secret__],
        return_mac:       "TARKISTE",
        separator:        "",
      },
      "Aktia" => {
        return_mac_over: ["NET_RETURN_VERSION", "NET_RETURN_STAMP", "NET_RETURN_REF", "NET_RETURN_PAID", :secret__],
        return_mac:       "NET_RETURN_MAC",
        separator:        "&",
      },
    }

    payment_provider_fields = fields[params[:servicename]]
    mac_over  = payment_provider_fields[:return_mac_over]
    mac_field = payment_provider_fields[:return_mac]
    separator = payment_provider_fields[:separator]

    # place the secret temporarily into the hash
    params[:secret__] = service_secret(params[:servicename], "payment")
    values = mac_over.map do |key|
      value = params[key]
      value = value.to_s.gsub(/\s+$/,"") if params[:servicename] == "Osuuspankki"  # spec requires removing end blanks
      value
    end
    params.delete :secret__   # remove temporary key


    bank_specific_checks = true  # by default
    if params[:servicename] == "Nordea"
      bank_specific_checks = params["SOLOPMT_RETURN_PAID"] != ""
    end
    bank_specific_checks or raise "Invalid bank_specific_checks"

    string_for_mac = values.join(separator) + separator
    puts "String for mac: #{string_for_mac}"
    mac = Digest::MD5.new.update(string_for_mac).hexdigest.upcase
    puts "MAC:            #{mac}"
    params[mac_field] == mac or raise "Invalid return mac"
  end

  def validate_successful_authentication!
    mac(service_provider_params_as_string({id: params[:id]}, [:id])) == params[:security_token]
  end


  def successful_authentication
    # let's check we are here with right params, ie. signature id matches the secret
    validate_successful_authentication!
    render nothing: true
  end

end
