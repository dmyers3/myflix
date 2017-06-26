require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    before do
      set_current_user
    end
    
    it "sets the @invitation variable to a new invitation" do
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_a(Invitation)
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end
  
  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    
    context "with valid input" do
      it "redirects to the invitation new page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joseph@example.com",
        message: "Join this!"}
        expect(response).to redirect_to new_invitation_path
      end
      
      it "creates an invitation" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joseph@example.com",
        message: "Join this!"}
        expect(Invitation.count).to eq(1)
      end
      
      it "sends an email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joseph@example.com",
        message: "Join this!"}
        expect(AppMailer.deliveries.last.to).to eq(["joseph@example.com"])
      end
      
      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joseph@example.com",
        message: "Join this!"}
        expect(flash[:success]).to be_present
      end
    end
  end
end