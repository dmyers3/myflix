class SessionsController < ApplicationController
  before_action :logged_in_home_page, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash[:danger] = "Incorrect Email and/or Password"
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "You are signed out."
    redirect_to root_path
  end
  
end