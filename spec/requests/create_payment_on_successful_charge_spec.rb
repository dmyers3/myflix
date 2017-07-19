require 'spec_helper'

describe "Create payment on successful charge" do
  it "creates a payment with the webhook from stripe for charge succeeded" do
    post "/stripe_events"
  end
end