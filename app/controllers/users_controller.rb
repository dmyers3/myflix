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
    
    if @user.save
      session[:user_id] = @user.id
      AppMailer.welcome(current_user).deliver
      flash[:success] = "Account created!"
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      token = params[:stripeToken] || "tok_visa"
      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :description => "#{@user.email} Sign up charge",
        :source => token,
      )
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