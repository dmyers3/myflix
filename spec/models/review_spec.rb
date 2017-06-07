require 'spec_helper'

describe Review do
  it { should belong_to(:video)}
  it { should belong_to(:user)}
  it { should validate_presence_of(:stars)}
  
  describe "#average_rating" do
    
  end
end