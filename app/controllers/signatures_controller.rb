#encoding: UTF-8

class SignaturesController < ApplicationController
  before_filter :authenticate_citizen!
  
  respond_to :html

  def new
    @signature = Signature.new()
    @signature.idea = Idea.find(params[:idea] || 4)
    @signature.citizen = current_citizen
    @signature.state = "initial"

    @services = [
      { action_id:  "701",
        vers:       "0001",
        rcvid:      "Elisa testi",
        langcode:   "FI",
        stamp:      "20120410091600000001",
        idtype:     "12",
        retlink:    "https://mobilesignature.herokuapp.com/signature/#{1}/returning",
        canlink:    "https://mobilesignature.herokuapp.com/signature/#{1}/cancelling",
        rejlink:    "https://mobilesignature.herokuapp.com/signature/#{1}/rejecting", 
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Mobiilivarmenne",
        url:        "https://mtupaspreprod.elisa.fi/tunnistus/signature.cmd", 
      }
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
      print string
      service[:mac] = Digest::SHA256.new.update(string).hexdigest.upcase
    end

    if @signature.save
      # all good
    else
      raise "couldn't save Signature #{@signature}"
    end
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
