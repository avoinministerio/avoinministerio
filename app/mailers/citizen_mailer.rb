class CitizenMailer < ActionMailer::Base
  default from: "avointesting@gmail.com"

  def welcome_email(user, proposals, famous_ideas)
    @f_ideas, @user, @proposals = famous_ideas, user, proposals

    mail(:to => @user.email, :subject => "Welcome to AvoinMinisterio")
  end
end
