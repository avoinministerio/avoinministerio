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
#        stamp:      "20120410091600000001",
        stamp:      DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s,
        idtype:     "12",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting", 
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Mobiilivarmenne",
        url:        "https://mtupaspreprod.elisa.fi/tunnistus/signature.cmd", 
      },
=begin
      { action_id:  "701",
        vers:       "0001",
        rcvid:      "Elisa testi",
        langcode:   "EN",
        stamp:      (1333377795 + rand(100000)).to_s,
        idtype:     "02",
        retlink:    "https://80.88.186.245/Main/Return",
        canlink:    "https://80.88.186.245/Main/Cancel",
        rejlink:    "https://80.88.186.245/Main/Rejected", 
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Mobiilivarmenne test2",
        url:        "https://mtupaspreprod.elisa.fi/tunnistus/signature.cmd", 
      }
=end
    ]

    @services.each do |service| 
      secret = service_secret(service[:rcvid])
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
      secret = ENV[secret_key]
      secret = "" unless secret
      secret
  end

  def mac(string)
    Digest::SHA256.new.update(string).hexdigest.upcase
  end

  def valid_returning(signature)
    logger.info params.inspect
    puts params.inspect
    values = %w(VERS TIMESTMP IDNBR STAMP CUSTNAME KEYVERS ALG CUSTID CUSTTYPE).map {|key| params["B02K_" + key]}
    #service = @signature.service
    service = "Elisa testi"
    puts "in valid returning"
    p service_secret(service)
    p values[0,9].join("&")
    string = values[0,9].join("&") + "&" + service_secret(service) + "&"
    puts string
    puts mac(string)
    puts params["B02K_MAC"]
    params["B02K_MAC"] == mac(string)
  end

  def back
    @signature = Signature.find(params[:id])
    case params[:returncode]
    when "returning"
      if not valid_returning(@signature)
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
    when "rejecting"
      logger.info "save"
      logger.info "notify client with a page that redirects back to sign"
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
