module ConversationsHelper
  def get_participants(message)
    message.participants.map { |c| c.name }.join(', ') 
  end
end
