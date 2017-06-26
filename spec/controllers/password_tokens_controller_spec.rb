require 'spec_helper'

describe PasswordTokensController do
  describe "POST create" do
    context "with blank input" do
      it "renders the forgot password page" do
        post :create, email: ""
        expect(response).to render_template(:new)
      end
      it "shows an error message" do
        post :create, email: ""
        expect(flash[:danger]).not_to be_nil
      end
    end
    
    context "with exisiting email" do
      it "redirects to the confirm password reset page" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(response).to redirect_to confirm_reset_password_path
      end
      
      it "sends out an email to the email address" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(AppMailer.deliveries.last.to).to eq(["joe@example.com"])
      end
    end
    
    context "with non-exisiting email" do
      it "renders the forgot password page" do
        post :create, email: "nonexisting@example.com"
        expect(response).to render_template(:new)
      end
      
      it "doesn't send out an email" do
        mailer_count = AppMailer.deliveries.count
        post :create, email: "nonexisting@example.com"
        expect(AppMailer.deliveries.count).to eq(mailer_count)
      end
      
      it "shows an error message" do
        post :create, email: "nonexisting@example.com"
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end