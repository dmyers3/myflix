require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user if not logged in" do
      get :new
      expect(assigns(:user)).to be_a(User)
    end
    
    it "redirects to home page if logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    it "redirects to home page if logged in" do
      session[:user_id] = Fabricate(:user).id
      post :create
      expect(response).to redirect_to home_path
    end
    
    context "with valid input" do
      before { post :create, user: Fabricate.attributes_for(:user) }
      
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
    end
    
    context "with invalid input" do
      before { post :create, user: { password: "password", full_name: "Dan Myers" }}
      
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      
      it "renders the :new template" do
        expect(response).to render_template :new
      end
      
      it "sets @user" do
        expect(assigns(:user)).to be_a(User)
      end
    end
    
    
    
  end
end