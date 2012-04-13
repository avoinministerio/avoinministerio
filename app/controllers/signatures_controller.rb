#encoding: UTF-8

require 'date'

class SignaturesController < ApplicationController
  before_filter :authenticate_citizen!
  
  respond_to :html

  def sign
    @signature = Signature.new()
    @signature.idea = Idea.find(params[:id] || 4)
    @signature.citizen = current_citizen
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
        idtype:     "02",
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
      keys = [:action_id, :vers, :rcvid, :langcode, :stamp, :idtype, :retlink, :canlink, :rejlink, :keyvers, :alg]
      secret_key = "SECRET_" + service[:rcvid].gsub(/\s/, "")
#      vals = keys.map{|k| service[k].gsub(/\s/, "") }
      vals = keys.map{|k| service[k] }
      logger.info "Using key #{secret_key}" 
      secret = ENV[secret_key]
      secret = "" unless secret
      string = vals.join("&") + "&" + secret + "&"
      puts string
      service[:mac] = Digest::SHA256.new.update(string).hexdigest.upcase
    end

    respond_with @signature
  end

  def valid_returning
    logger.info params.inspect
    false
  end

  def back
    @signature = Signature.find(params[:id])
    case params[:returncode]
    when "returning"
      if not valid_returning
        logger.info "save invalidity"
        logger.info "notify client with redirect back to sign"
      elsif not within timelimit
        logger.info "save invalidity"
        logger.info "notify client with redirect back to sign"
      elsif repeated returning
        logger.info "save invalidity"
        logger.info "notify client with redirect back to sign"
      else
        # all success!
        logger.info "save"
        logger.info "notify client with a page that redirects back to idea"
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
