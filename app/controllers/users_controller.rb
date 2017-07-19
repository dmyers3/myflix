class UsersController < ApplicationController
  before_action :logged_in_home_page, only: [:front, :new, :create]
  before_action :redirect_logged_out, only: [:show]
  
  def front
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken])
    if result.successful?
      flash[:success] = "Account created!"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash[:danger] = result.error_message
      render 'new'
    end
  end
    
    
  
  private
  
    def user_params
      params.require('user').permit('email', 'password', 'full_name')
    end
    
    
    
end