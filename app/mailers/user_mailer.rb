class UserMailer < ActionMailer::Base
  default from: 'larklims-demo.larkbio.com'

  def register_email(user)
    @user = user
    @url  = 'http://larklims-demo.larkbio.com'
    mail(to: ENV['ADMIN_EADDR'], subject: 'LarkLims registration')
  end

  def welcome_email(user)
    @user = user
    @url  = 'http://larklims-demo.larkbio.com'
    mail(to: @user.email, subject: 'Welcome to LarkLims')
  end
end