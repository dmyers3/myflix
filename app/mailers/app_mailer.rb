class AppMailer < ActionMailer::Base
  def welcome(user)
    mail from: 'MyFlix <welcome@MyFlix.com>', to: user.email, subject: 'Welcome!'
  end
  
  def send_password_reset(user)
    @token = user.token
    mail from: 'MyFlix <reset@MyFlix.com>', to: user.email, subject: "Reset Password"
  end
  
  def send_invitation_email(invitation)
    @invitation = invitation
    mail from: 'info@myflix.com', subject: "A Friend Invites you to join MyFlix",
    to: invitation.recipient_email
  end
  
  def card_declined(user)
    mail from: 'MyFlix <info@MyFlix.com>', to: user.email, subject: "Your Account is on hold"
  end
  
  # to execute in a controller do AppMailer.example(user, object).deliver
end