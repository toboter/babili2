class AdminMailer < ApplicationMailer
  default from: 'auth@babylon-online.org'
  layout 'mailer'

  def new_user_waiting_for_approval(user)
    @email = user.email
    mail(to: User.admin.pluck(:email), subject: '[babylon-online.org][Administrative] New user is awaiting approval.')
  end

end
