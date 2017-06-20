class AppMailer < ActionMailer::Base
  def example(user, object)
    @object = object
    mail from: 'example@example.com', to: user.email, subject: 'Testing'
  end
  
  # to execute in a controller do AppMailer.example(user, object).deliver
end