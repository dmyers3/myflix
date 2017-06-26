class PasswordTokensController < ApplicationController
  before_action :redirect_logged_out, only: [:destroy]
  before_action :logged_in_home_page, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user
      user.token = assign_token
      user.save
      AppMailer.send_password_reset(user).deliver
      flash[:success] = "Password Reset email sent."
      redirect_to confirm_reset_password_path
    else
      flash[:danger] = "Could not find email address."
      render 'new'
    end
    
  end
  
  def destroy
  end
  
  def confirm
  end
  
  private
  
  def assign_token
    token = SecureRandom.urlsafe_base64
    if User.find_by(token: token)
      assign_token
    else
      return token
    end
  end
end