module StripeWrapper
  class Charge
    attr_reader :response, :status
    
    def initialize(response, status)
      @response = response
      @status = status
    end
    
    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(amount: options[:amount], 
          description: options[:description], source: options[:source], currency: 'usd')
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      rescue => e
        new(e, :error)
      end
    end
    
    def successful?
      status == :success
    end
    
    def error_message
      response.message
    end
  end
  
  class Customer
    attr_reader :response, :status, :id
    
    def initialize(response, status)
      @response = response
      @status = status
    end
    
    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Customer.create(email: options[:email], 
          source: options[:source])
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      rescue => e
        new(e, :error)
      end
    end
    
    def customer_token
      response.id
    end
    
    def successful?
      status == :success
    end
    
    def error_message
      response.message
    end
  end
  
  class Subscription
    def self.create(options={})
      StripeWrapper.set_api_key
      response = Stripe::Subscription.create(customer: options[:customer], plan: options[:plan])
    end
  end
  
  def self.set_api_key
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end
end