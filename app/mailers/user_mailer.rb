class UserMailer < ApplicationMailer
  default from: 'admin@babylon-online.org'
  
  def account_approved(user)
    @user = user
    @url  = new_user_session_url
    mail(to: @user.email, subject: '[babylon-online.org] Your account has been approved.')
  end
end