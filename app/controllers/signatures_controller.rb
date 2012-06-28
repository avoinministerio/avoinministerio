#encoding: UTF-8

require 'date'

class SignaturesController < ApplicationController
  before_filter :authenticate_citizen!

  respond_to :html

  def introduction
  end

  def approval
  end

  def sign
    @signature                  = Signature.new()
    @signature.idea             = Idea.find(params[:id])
    @signature.citizen          = current_citizen
    @signature.idea_title       = @signature.idea.title
    @signature.idea_date        = @signature.idea.updated_at
    @signature.firstnames       = @signature.citizen.first_name
    @signature.lastname         = @signature.citizen.last_name

    @signature.occupancy_county = ""
    @signature.vow              = false
    @signature.state            = "initial"

    stamp = DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s
    @signature.stamp            = stamp

    @signature.started          = Time.now

    unless @signature.save
      raise "couldn't save Signature #{@signature}"
    end

    server = "https://#{request.host_with_port}"
    Rails.logger.info "Server is #{server}"

    @services = [
      { action_id:  "701",
        vers:       "0001",
        rcvid:      "",
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
        rcvid:      "",
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
        rcvid:      "",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "02",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting",
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Alandsbanken testi",
        url:        "https://online.alandsbanken.fi/ebank/auth/initLogin.do",
      },
      { action_id:  "701",
        vers:       "0002",
        rcvid:      "",
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


      { action_id:  "701",
        vers:       "0002",
        rcvid:      "",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "02",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting",
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Tapiola testi",
        url:        "https://pankki.tapiola.fi/service/identify",
      },
      { action_id:  "701",
        vers:       "0002",
        rcvid:      "",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "02",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting",
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Tapiola",
        url:        "https://pankki.tapiola.fi/service/identify",
      },

      { action_id:  "701",
        vers:       "0003",
        rcvid:      "",
        langcode:   "FI",
        stamp:      stamp,
        idtype:     "02",
        retlink:    "#{server}/signatures/#{@signature.id}/returning",
        canlink:    "#{server}/signatures/#{@signature.id}/cancelling",
        rejlink:    "#{server}/signatures/#{@signature.id}/rejecting",
        keyvers:    "0001",
        alg:        "03",
        mac:        nil,
        name:       "Sampo",
        url:        "https://verkkopankki.sampopankki.fi/SP/tupaha/TupahaApp",
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
      service[:rcvid] = service_rcvid(service[:name])
      keys = [:action_id, :vers, :rcvid, :langcode, :stamp, :idtype, :retlink, :canlink, :rejlink, :keyvers, :alg]
      vals = keys.map{|k| service[k] }
      string = vals.join("&") + "&" + secret + "&"
      service[:mac] = mac(string)
    end

    respond_with @signature
  end

  def service_rcvid(service)
    rcvid_key = "RCVID_" + service.gsub(/\s/, "")
    rcvid = ENV[rcvid_key] || ""
  end

  def service_secret(service)
    secret_key = "SECRET_" + service.gsub(/\s/, "")

    Rails.logger.info "Using key #{secret_key}"
    secret = ENV[secret_key] || ""

    if service == "Alandsbanken" or service == "Tapiola"
      secret = secret_to_mac_string(secret)
      Rails.logger.info "Converting secret to #{secret}"
    end

    unless secret
      Rails.logger.error "No SECRET found for #{secret_key}"
      secret = ""
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


  def valid_returning(signature, service_name)
    Rails.logger.info params.inspect
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

  def within_timelimit(signature)
    elapsed = (Time.now - signature.started)#*(60*60*24) # in seconds
    timelimit = (20*60)   # 20 mins
    within = elapsed <= timelimit
    Rails.logger.info "#{Time.now} - #{signature.started} = #{elapsed} which > #{timelimit}" unless within
    within
  end

  def repeated_returning(signature)
    signature.state == "initial"
  end

  def back
    @signature = Signature.find(params[:id])   # TODO: Add find for current_citizen
    if not @signature.citizen == current_citizen
      Rails.logger.info "Invalid user, not for the same user who initiated the signing"
      @error = "Invalid user"
    else
      service_name = params[:servicename]
      case params[:returncode]
      when "returning"
        if not valid_returning(@signature, service_name)
          Rails.logger.info "Invalid return"
          @signature.update_attributes(state: "invalid return")
          @error = "Invalid return"
        elsif not within_timelimit(@signature)
          Rails.logger.info "not within timelimit"
          @signature.update_attributes(state: "too late")
          @error = "Not within timelimit"
        elsif not repeated_returning(@signature)
          Rails.logger.info "repeated returning"
          @signature.update_attributes(state: "repeated_returning")
          @error = "Repeated returning"
        else
          # all success!
          Rails.logger.info "All success, authentication ok, storing into session"
          @error = nil
          birth_date = hetu_to_birth_date(params["B02K_CUSTID"])
          @signature.update_attributes(state: "authenticated", signing_date: today_date(), birth_date: birth_date)
          session["authenticated_at"] = DateTime.now
          session["authenticated_birth_date"] = birth_date
        end
      when "cancelling"
        Rails.logger.info "Cancelling"
        @signature.update_attributes(state: "cancelled")
        @error = "Cancelling authentication"
      when "rejecting"
        Rails.logger.info "Rejecting"
        @signature.update_attributes(state: "rejected")
        @error = "Rejecting authentication"
      else
        Rails.logger.info "notify client"
      end
    end

    respond_with @signature
  end

  def finalize_signing
#    @signature = current_citizen.signatures.where(state: 'authenticated').find(params[:id])
    @signature = Signature.where(state: 'authenticated').find(params[:id])
    if @signature.citizen == current_citizen and @signature.state == "authenticated"   # TODO: and duration since last authentication less that threshold
      @signature.firstnames       = params["signature"]["firstnames"]
      @signature.lastname         = params["signature"]["lastname"]
      @signature.occupancy_county = params["signature"]["occupancy_county"]
      @signature.vow              = params["signature"]["vow"]
      @signature.state            = "signed"
      @signature.signing_date     = today_date
      @error = "Couldn't save signature" unless @signature.save

      # show only proposals that haven't yet been signed by current_user
      signatures = Arel::Table.new(:signatures)
      already_signed = Signature.where(signatures[:state].eq('signed'), signatures[:citizen].eq(current_citizen.id)).find(:all, select: "idea_id").map{|s| s.idea_id}.uniq
      ideas = Arel::Table.new(:ideas)
      proposals_not_in_already_signed = (ideas[:state].eq('proposal')).and(ideas[:id].not_in(already_signed))
      @initiatives = Idea.where(proposals_not_in_already_signed).order("vote_for_count DESC").limit(5).all
    else
      @error = "Trying to alter other citizen or signature with other than authenticated state"
    end
    respond_with @signature
  end

end
