require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    context "with valid credentials" do
      it "puts the signed in user in the session" do
        dan = Fabricate(:user)
        post :create, email: dan.email, password: dan.password
        expect(session[:user_id]).to eq(dan.id)
      end
      
      it "redirects to the home page" do
        dan = Fabricate(:user)
        post :create, email: dan.email, password: dan.password
        expect(response).to redirect_to home_path
      end
    end
    
    context "with invalid credentials" do
      it "gives error message" do
        dan = Fabricate(:user)
        post :create, email: dan.email, password: dan.password + 'sadklsaf'
        expect(flash[:danger]).not_to be_blank
      end
      
      it "does not put the signed in user in the session" do
        dan = Fabricate(:user)
        post :create, email: dan.email, password: dan.password + 'sadklsaf'
        expect(session[:user_id]).to eq(nil)
      end
      
      it "redirects to the home page" do
        dan = Fabricate(:user)
        post :create, email: dan.email, password: dan.password + 'sadklsaf'
        dan = Fabricate(:user)
        post :create, email: dan.email, password: dan.password + 'sadklsaf'
      end
    end
  end
  
  describe "GET destroy" do
    it "clears the session for the user" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be_nil
    end
    
    it "redirects to the root path" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end