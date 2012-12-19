class CitizenMailer < ActionMailer::Base
  default from: "avointesting@gmail.com"
  
  def welcome_email(user, proposals, famous_ideas)
    @f_ideas = famous_ideas
    @user = user
    @proposals = proposals
    attachments.inline['email_logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    mail(:to => @user.email, :subject => "Welcome to AvoinMinisterio")
  end
end
