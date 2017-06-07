require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "sets the @video variable" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
      
      it "sets the @reviews instance variable" do
        video = Fabricate(:video)
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        review1 = Fabricate(:review, video: video, user: user1)
        review2 = Fabricate(:review, video: video, user: user2)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review2, review1])
      end
      
      # tests Rails code, so no need:
      # it "renders the show template" do
      #   video = Fabricate(:video)
      #   get :show, id: video.id
      #   expect(response).to render_template :show
      # end
    end
    
    context "with unauthenticated users" do
      it "redirects to the root route" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "GET search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      lost = Fabricate(:video, title: "Lost")
      get :search, query: 'lost'
      expect(assigns(:videos)).to eq([lost])
    end
    it "redirects to the root route for unauthenticated users" do
      lost = Fabricate(:video, title: "lost")
      get :search, query: "lost"
      expect(response).to redirect_to root_path
    end
  end
end