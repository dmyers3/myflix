class UsersController < ApplicationController
  before_action :logged_in_home_page, only: [:front, :new, :create]
  
  def front
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Account created!"
      redirect_to home_path
    else
      render 'new'
    end
  end
  
  private
  
    def user_params
      params.require('user').permit('email', 'password', 'full_name')
    end
    
end