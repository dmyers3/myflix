require 'spec_helper'

describe Video do
  
  # This tests rails functionality - only test code you own
  # it "saves itself" do
  #   video = Video.new(title: "Lost", description: "Lost on an island",
  #   small_cover_url: "/tmp/lost.jpg", large_cover_url: "/tmp/lost_large.jpg")
  #   video.save
  #   # Video.first.title.should == "Lost"
  #   expect(Video.first.title).to eq("Lost")
  # end
  
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it { should have_many(:reviews).order("created_at DESC")}
  
  # above shoulda-matcher replaces these:
  # it "belongs to a category" do
  #   category = Category.create(name: "Dramas")
  #   video = Video.create(title: "Lost", description: "Lost on an island",
  #     category: category)
  #   video.category.should == category
  #   # expect(video.category).to eq(category)
  # end
  
  # it "has a title" do
  #   video = Video.new(description: "Lost on an island")
  #   video.valid?
  #   # expect(video.errors[:title]).to include("can't be blank")
  #   video.errors[:title].should include("can't be blank")
  # end
  
  # it "has a description" do
  #   video = Video.new(title: "Lost")
  #   video.valid?
  #   expect(video.errors[:description]).to include("can't be blank")
  # end
  
  describe "#search_by_title" do
    it "returns empty array if can't find match" do
      lost = Video.create(title: "Lost", description: "Island adventure")
      expect(Video.search_by_title("Monk")).to eq([])
    end
    
    it "returns array of one if there is one match" do
      lost = Video.create(title: "Lost", description: "Island adventure")
      expect(Video.search_by_title("Lost")).to eq([lost])
    end
    
    it "returns array with multiple elements ordered by created_at" do
      lost = Video.create(title: "Lost", description: "Island adventure", created_at: 1.day.ago)
      lost2 = Video.create(title: "Lost", description: "Island adventure remake")
      expect(Video.search_by_title("Lost")).to eq([lost2, lost])
    end
    
    it "returns matching array regardless of case" do
      lost = Video.create(title: "Lost", description: "Island adventure")
      expect(Video.search_by_title("lost")).to eq([lost])
    end
    
    it "returns matching array if search matches part of title" do
      lost = Video.create(title: "Lost", description: "Island adventure")
      expect(Video.search_by_title("los")).to eq([lost])
    end
    
    it "returns an empty array if search term is empty" do
      lost = Video.create(title: "Lost", description: "Island adventure")
      expect(Video.search_by_title("")).to eq([])
    end
  end
  
  describe "#most_recent" do
    it "returns empty array if no videos exist" do
      expect(Video.most_recent).to eq([])
    end
    
    it "returns all videos ordered by created_at if less than 6 vids exist" do
      monk = Video.create(title: "Monk", description: "Detective show",
        created_at: 1.day.ago)
      lost = Video.create(title: "Lost", description: "Island adventure")
      
      expect(Video.most_recent).to eq([lost, monk])
    end
    
    it "returns most recent 6 vids orderd by created_at if at least 6 exist" do
      monk = Video.create(title: "Monk", description: "Detective show",
        created_at: 1.day.ago)
      lost = Video.create(title: "Lost", description: "Island adventure")
      law_and_order = Video.create(title: "Law and Order", description: "Detective show",
        created_at: 2.days.ago)
      gilligan = Video.create(title: "Gilligan's Island", description: "Island adventure")
      cops = Video.create(title: "Cops", description: "Detective show",
        created_at: 3.days.ago)
      lost_in_space = Video.create(title: "Lost in Space", description: "Space adventure")
      reno_911 = Video.create(title: "Reno 911", description: "Detective show",
        created_at: 4.days.ago)
      
      expect(Video.most_recent).to eq([lost_in_space, gilligan, lost, monk, 
        law_and_order, cops])
    end
  end
end