require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets relationships to the current user's following relationships" do
      dan = Fabricate(:user)
      set_current_user(dan)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: dan)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  
  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end
    
    it "deletes the relationship if the current user is the follower" do
      dan = Fabricate(:user)
      set_current_user(dan)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: dan, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    
    it "redirects to the people page" do
      dan = Fabricate(:user)
      set_current_user(dan)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: dan, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to(people_path)
    end
    
    it "does not delete the relationship if the current user is not the follower" do
      dan = Fabricate(:user)
      set_current_user(dan)
      greg = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: greg, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
    
    describe "POST create" do
      it_behaves_like "requires sign in" do
        let(:action) {post :create, leader_id: 1 }
      end
      
      it "creates a relationship that the current user follows the leader" do
        dan = Fabricate(:user)
        set_current_user(dan)
        bob = Fabricate(:user)
        post :create, leader_id: bob.id
        expect(dan.leaders).to eq([bob])
      end
      
      it "redirects to the people page" do
        dan = Fabricate(:user)
        set_current_user(dan)
        bob = Fabricate(:user)
        post :create, leader_id: bob.id
        expect(response).to redirect_to people_path
      end
      
      it "does not create a relationship if the current user already follows the leader" do
        dan = Fabricate(:user)
        set_current_user(dan)
        bob = Fabricate(:user)
        post :create, leader_id: bob.id
        post :create, leader_id: bob.id
        expect(Relationship.count).to eq(1)
      end
      
      it "does not allow one to follow themselves" do
        dan = Fabricate(:user)
        set_current_user(dan)
        post :create, leader_id: dan.id
        expect(Relationship.count).to eq(0)
      end
    end
  end
end