#encoding: UTF-8

require 'date'

class SignaturesController < ApplicationController
  before_filter :authenticate_citizen!
  
  respond_to :html

  def sign
    @signature = Signature.new()
    @signature.idea = Idea.find(params[:id] || 4)
    @signature.citizen = current_citizen
    @signature.idea_title = @signature.idea.title
    @signature.idea_date  = @signature.idea.updated_at
    @signature.fullname = @signature.citizen.name
    # @signature.birth_date = ""
    @signature.occupancy_county = ""
    @signature.vow = false
    @signature.state = "initial"

    stamp = DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s
    @signature.stamp = stamp

    if @signature.save
      # all good
    else
      raise "couldn't save Signature #{@signature}"
    end

    server = "https://am-signing.herokuapp.com"
    logger.info "Server is #{server}"
    server = "https://" + request.host
    server += ":" + request.port.to_s unless request.port == 80
    logger.info "Server is #{server}"
    puts request.host
    puts request.host_with_port
    puts request.subdomain
    puts request.subdomains
#    puts request.inspect
    logger.error "Server is #{server}"

    @services = [
      { action_id:  "701",
        vers:       "0001",
        rcvid:      "Elisa testi",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "12",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting", 
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Elisa Mobiilivarmenne testi",
        url:        "https://mtupaspreprod.elisa.fi/tunnistus/signature.cmd", 
      },
      { action_id:  "701",
        vers:       "0001",
        rcvid:      "Avoinministerio",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "12",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting", 
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Elisa Mobiilivarmenne",
        url:        "https://tunnistuspalvelu.elisa.fi/tunnistus/signature.cmd", 
      },

      { action_id:  "701",
        vers:       "0002",
        rcvid:      "ELEKAMINNID",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "02",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting", 
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Alandsbanken",
        url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do", 
      },
    ]

    @services.each do |service|
      service_name = "/" + service[:name].gsub(/\s+/, "")
      service[:retlink] += service_name
      service[:canlink] += service_name
      service[:rejlink] += service_name
    end
    @services.each do |service| 
      secret = service_secret(service[:name])
      keys = [:action_id, :vers, :rcvid, :langcode, :stamp, :idtype, :retlink, :canlink, :rejlink, :keyvers, :alg]
#      vals = keys.map{|k| service[k].gsub(/\s/, "") }
      vals = keys.map{|k| service[k] }
      string = vals.join("&") + "&" + secret + "&"
      puts string
      service[:mac] = mac(string)
    end

    respond_with @signature
  end

  def service_secret(service)
      secret_key = "SECRET_" + service.gsub(/\s/, "")
      logger.info "Using key #{secret_key}" 
      puts "Using key #{secret_key}" 
      secret = ENV[secret_key]
      unless secret
        logger.error "No SECRET found for #{secret_key}" 
        puts "No SECRET found for #{secret_key}"
        secret = "" 
      end

      secret
  end

  def mac(string)
    Digest::SHA256.new.update(string).hexdigest.upcase
  end

  def valid_returning(signature, service_name)
    logger.info params.inspect
    puts params.inspect
    values = %w(VERS TIMESTMP IDNBR STAMP CUSTNAME KEYVERS ALG CUSTID CUSTTYPE).map {|key| params["B02K_" + key]}
    puts "in valid returning"
    p service_name
    p service_secret(service_name)
    p values[0,9].join("&")
    string = values[0,9].join("&") + "&" + service_secret(service_name) + "&"
    puts string
    puts mac(string)
    puts params["B02K_MAC"]
    params["B02K_MAC"] == mac(string)
  end

  def back
    @signature = Signature.find(params[:id])
    service_name = params[:servicename]
    case params[:returncode]
    when "returning"
      if not valid_returning(@signature, service_name)
        logger.info "Invalid return"
        logger.info "save invalidity"
        logger.info "notify client with redirect back to sign"
        @error = "Invalid return"
      elsif not "within timelimit"
        logger.info "not within timelimit"
        logger.info "save invalidity"
        logger.info "notify client with redirect back to sign"
        @error = "Not within timelimit"
      elsif not "repeated returning"
        logger.info "repeated returning"
        logger.info "save invalidity"
        logger.info "notify client with redirect back to sign"
        @error = "Repeated returning"
      else
        # all success!
        logger.info "save"
        logger.info "notify client with a page that redirects back to idea"
        @error = nil
        bd = params["B02K_CUSTID"].gsub(/\-.+$/, "")
        birth_date = Date.new(1900+bd[4,2].to_i, bd[2,2].to_i, bd[0,2].to_i)
        p birth_date
        @signature.update_attributes(state: "completed", signing_date: Date.today, birth_date: birth_date)
      end
    when "cancelling"
      logger.info "redirect to sign"
      @error = "Repeated returning"
    when "rejecting"
      logger.info "save"
      logger.info "notify client with a page that redirects back to sign"
      @error = "Repeated returning"
    else
      logger.info "notify client"
    end
        
    logger.info @signature.inspect
    respond_with @signature
  end


  def create
    @signature = Signature.new()
    @signature.idea = Idea.find(params[:signature][:idea])
    @signature.citizen = current_citizen
    @signature.state = "initial"
    if @signature.save
      flash[:notice] = I18n.t("signature.created")
      KM.identify(current_citizen)
      KM.push("record", "signing initiated", signature_id: @signature.id,  idea_id: @signature.idea.id, idea_title: @signature.idea.title) 
    end
    respond_with @signature
  end

  def show
    @article = Article.find(params[:id])

    KM.identify(current_citizen)
    KM.push("record", "article read", article_id: @article.id,  article_title: @article.title)  # TODO use permalink title

    respond_with @article
  end
  
end
