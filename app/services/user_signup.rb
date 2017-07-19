class UserSignup
  attr_reader :error_message
  
  def initialize(user)
    @user = user
  end
  
  def sign_up(stripe_token)
    if @user.valid? && valid_card_charge?(stripe_token)
      @user.customer_token 
      @user.save
      AppMailer.welcome(@user).deliver
      @status = :success
      self
    else
      @status = :failure
      self
    end
  end
  
  def successful?
    @status == :success
  end
  
  private
  
  def valid_card_charge?(stripe_token)
    token = Rails.env.test? ? "tok_visa" : stripe_token
    customer = StripeWrapper::Customer.create( :email => "#{@user.email}", :source => token)
    if customer.successful?
      StripeWrapper::Subscription.create(
        customer: customer.response.id, plan: "monthly")
        @user.customer_token = customer.customer_token
      true
    else
      @error_message = customer.error_message
      false
    end
  end
end