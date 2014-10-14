class UserMailer < ActionMailer::Base
  default from: 'larklims-demo.larkbio.com'

  def register_email(user)
    @mailgun = Mailgun()
    @user = user
    @url  = 'http://larklims-demo.larkbio.com'
    parameters = {
        :to => ENV['ADMIN_EADDR'],
        :subject => "LarkLims registration",
        :text => "A user was registered to LarkLims, name: "+@user.name+" ,email: "+@user.email+" \nTo activate the user, follow this link and log in as admin: "+@url,
        :from => "larklims@larkbio.com"
        }
   @mailgun.messages.send_email(parameters)
  end

  def welcome_email(user)
    @mailgun = Mailgun()
     @user = user
     @url  = 'http://larklims-demo.larkbio.com'
     parameters = {
        :to => user.email,
        :subject => "Welcome to LarkLims",
        :text => "Welcome to LarkLims, "+@user.name+"\n Your account has been successfully activated. \n To login the site, just follow this link: "+@url,
        :from => "larklims@larkbio.com"
        }
    @mailgun.messages.send_email(parameters)
  end
end