class AppMailer < ActionMailer::Base
  def welcome(user)
    mail from: 'daniel.p.myers@gmail.com', to: user.email, subject: 'Welcome!'
  end
  
  # to execute in a controller do AppMailer.example(user, object).deliver
end