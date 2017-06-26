class NewPasswordsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = params[:id]
    else
      redirect_to expired_token_path
    end
  end
  
  def create
    user = User.find_by(token: params[:token])
    if user
      user.password = params[:password]
      if user.save
        flash[:success] = "Password successfully updated."
        user.token = nil
        user.save
        redirect_to login_path
      else
        flash[:error] = "Invalid password"
        render 'show'
      end
    else
      redirect_to expired_token_path
    end
  end
  
  def expired_token
  end
end