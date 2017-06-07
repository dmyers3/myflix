require 'spec_helper'

describe QueuePositionsController do
  describe "GET index" do
     it "sets @user_queue to the queue of the logged in user" do
      dan = Fabricate(:user)
      set_current_user(dan)
      video_1 = Fabricate(:video)
      video_2 = Fabricate(:video)
      queue1 = Fabricate(:queue_position, user: dan, video: video_1)
      queue2 = Fabricate(:queue_position, user: dan, video: video_2)
      get :index
      expect(assigns(:user_queue)).to match_array([queue1, queue2])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  
  describe "POST create" do
    it "redirects to the my_queue page" do
    end
    
    it "creates a queue item" do
    end
    
    it "creates a queue item that is associated with the correct video" do
    end
    
    it "creates a queue item that is associated with the current user" do
    end
    
    it "makes the new queue position the last one in the queue" do
    end
    
    it "does not add vidoe to queue if video already exists in it" do
    end
  end
  
  describe "POST update_queue" do
    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue }
    end
    
    it "redirects to the my_queue page" do
      dan = Fabricate(:user)
      set_current_user(dan)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      queue1 = QueuePosition.create(position: 1, user: dan, video: video1)
      queue2 = QueuePosition.create(position: 2, user: dan, video: video2)
      post :update_queue, queue_positions: [{id: queue1.id, position: 2}, {id: queue2.id, position: 1}]
      expect(response).to redirect_to my_queue_path
    end
    
    it "reorders positions of 2 queue items" do
      dan = Fabricate(:user)
      set_current_user(dan)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      queue1 = QueuePosition.create(position: 1, user: dan, video: video1)
      queue2 = QueuePosition.create(position: 2, user: dan, video: video2)
      post :update_queue, queue_positions: [{id: queue1.id, position: 2}, {id: queue2.id, position: 1}]
      expect(QueuePosition.first).to eq(queue2)
    end
    
    it "normalizes the position numbers to start at 1" do
      dan = Fabricate(:user)
      set_current_user(dan)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      queue1 = QueuePosition.create(position: 1, user: dan, video: video1)
      queue2 = QueuePosition.create(position: 2, user: dan, video: video2)
      post :update_queue, queue_positions: [{id: queue1.id, position: 3}, {id: queue2.id, position: 2}]
      expect(queue1.reload.position).to eq(2)
      expect(queue2.reload.position).to eq(1)
    end
    
    context "with invalid inputs" do
      it "redirects to the my queue page" do
        dan = Fabricate(:user)
        set_current_user(dan)
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue1 = QueuePosition.create(position: 1, user: dan, video: video1)
        queue2 = QueuePosition.create(position: 2, user: dan, video: video2)
        post :update_queue, queue_positions: [{id: queue1.id, position: 3.4}, {id: queue2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end
      
      it "sets the flash error message" do
        dan = Fabricate(:user)
        set_current_user(dan)
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue1 = QueuePosition.create(position: 1, user: dan, video: video1)
        queue2 = QueuePosition.create(position: 2, user: dan, video: video2)
        post :update_queue, queue_positions: [{id: queue1.id, position: 3.4}, {id: queue2.id, position: 2}]
        expect(flash[:danger]).to be_present
      end
      
      it "does not change the queue items" do
        dan = Fabricate(:user)
        set_current_user(dan)
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue1 = QueuePosition.create(position: 1, user: dan, video: video1)
        queue2 = QueuePosition.create(position: 2, user: dan, video: video2)
        post :update_queue, queue_positions: [{id: queue1.id, position: 3}, {id: queue2.id, position: 2.1}]
        expect(dan.queue_positions).to eq([queue1, queue2])
      end
    end
  end
end
