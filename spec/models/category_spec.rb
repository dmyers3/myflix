require 'spec_helper'

describe Category do
  # Unnecessary testing of Rails
  # it "saves itself" do
  #   category = Category.new(name: "Dramas")
  #   category.save
  #   # Video.first.title.should == "Lost"
  #   expect(Category.first).to eq(category)
  # end
  
  it { should have_many(:videos) }
  
  # it "has many videos" do
  #   category = Category.create(name: "Dramas")
  #   lost = Video.create({title: "Lost", description: "Lost on an island",
  #     category: category})
  #   monk = Video.create({title: "Monk", description: "Detective", category:
  #     category})
    
  #   expect(category.videos).to eq([lost, monk])
  # end
  
  describe "#most_recent" do
    it "returns empty array if no videos exist" do
      dramas = Category.create(name: "dramas")
      expect(dramas.most_recent).to eq([])
    end
    
    it "returns all videos ordered by created_at if less than 6 vids exist" do
      dramas = Category.create(name: "dramas")
      monk = Video.create(title: "Monk", description: "Detective show",
        created_at: 1.day.ago, category: dramas)
      lost = Video.create(title: "Lost", description: "Island adventure", category: dramas)
      
      expect(dramas.most_recent).to eq([lost, monk])
    end
    
    it "returns most recent 6 vids orderd by created_at if at least 6 exist" do
      dramas = Category.create(name: "dramas")
      monk = Video.create(title: "Monk", description: "Detective show",
        created_at: 1.day.ago, category: dramas)
      lost = Video.create(title: "Lost", description: "Island adventure", category: dramas)
      law_and_order = Video.create(title: "Law and Order", description: "Detective show",
        created_at: 2.days.ago, category: dramas)
      gilligan = Video.create(title: "Gilligan's Island", description: "Island adventure", category: dramas)
      cops = Video.create(title: "Cops", description: "Detective show",
        created_at: 3.days.ago, category: dramas)
      lost_in_space = Video.create(title: "Lost in Space", description: "Space adventure", category: dramas)
      reno_911 = Video.create(title: "Reno 911", description: "Detective show",
        created_at: 4.days.ago, category: dramas)
      
      expect(dramas.most_recent).to eq([lost_in_space, gilligan, lost, monk, 
        law_and_order, cops])
    end
  end
end