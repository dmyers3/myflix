require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      context "with valid inputs" do
        before do
        end
        it "redirect_to the video show page" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id,
          user_id: user.id
          expect(response).to redirect_to video
        end
        
        it "creates a review" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id,
          user_id: user.id
          expect(Review.count).to eq(1)
        end
        
        it "creates a review associated with the video" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id,
          user_id: user.id
          expect(Review.first.video).to eq(video)
        end
        
        it "creates a review associated with the signed in user" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id,
          user_id: user.id
          expect(Review.first.user).to eq(user)
        end
        
        
      end
      
      context "with invalid input" do
      end
    end
    
    context "with unauthenticated users" do
    end
  end
end