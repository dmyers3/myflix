require 'spec_helper'

describe StripeWrapper::Charge do
  context "with valid card" do
    it "charges card successfully", :vcr do
      token = "tok_visa"
      response = StripeWrapper::Charge.create(amount: 300, source: token, description: "Test Charge")
      expect(response).to be_successful
    end
  end
  
  context "with invalid card" do
    let(:token) { "tok_chargeDeclined" }
    let(:response) { StripeWrapper::Charge.create(amount: 300, source: token, description: "Test Charge") }
    
    it "does not charge the card successfully", :vcr do
      expect(response).not_to be_successful
    end
    
    it "contains an error message", :vcr do
      expect(response.error_message).to eq("Your card was declined.")
    end
  end
end