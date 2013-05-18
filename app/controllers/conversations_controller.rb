require 'will_paginate/array'

class ConversationsController < ApplicationController
  before_filter :authenticate_citizen!
  helper_method :mailbox, :conversation
  
  def create
    recipient = Citizen.find(conversation_params(:recipients))
    conversation = current_citizen.send_message(recipient, *conversation_params(:body, :subject)).conversation
    redirect_to conversation
  end

  def reply
    current_citizen.reply_to_conversation(conversation, *message_params(:body, :subject))
    redirect_to conversation
  end

  def trash
    conversation.move_to_trash(current_citizen)
    redirect_to conversations_path
  end

  def untrash
    conversation.untrash(current_citizen)
    redirect_to conversations_path
  end

  def show_inbox
    @inbox = mailbox.inbox.page(params[:page]).per_page(10)
  end

  def show_sentbox
    @sentbox = mailbox.sentbox.page(params[:page]).per_page(10)
  end

  def show_trash
    @trash = mailbox.trash.page(params[:page]).per_page(10)
  end
  
  def get_participants
    @participants = current_citizen.connections
    respond_to do |format|
       format.html
       format.json { render json: @participants }
    end
  end

  def new
    @participants = current_citizen.connections
    if params[:recipient_id] != nil
      @pre_load = [{id: params[:recipient_id], name: Citizen.find(params[:recipient_id]).name}]
    end
  end

  def index
    @inbox = mailbox.inbox.limit(5)
    @sentbox = mailbox.sentbox.limit(5)
    @trash = mailbox.trash.limit(5)
  end

  private

  def mailbox
    @mailbox ||= current_citizen.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end