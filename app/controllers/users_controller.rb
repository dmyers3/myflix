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
    
    if @user.valid? && valid_card_charge
      @user.save
      session[:user_id] = @user.id
      AppMailer.welcome(current_user).deliver
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
    
    def valid_card_charge
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      token = Rails.env.test? ? "tok_visa" : params[:stripeToken]
      begin
        charge = Stripe::Charge.create(
          :amount => 999,
          :currency => "usd",
          :description => "#{@user.email} Sign up charge",
          :source => token,
        )
        return true
      rescue Stripe::CardError => e
        flash[:danger] = e.message
        return false
      rescue => e
        flash[:danger] = "Some error occurred."
        return false
      end
    end
    
end