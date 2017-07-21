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
  
  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end
    
    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index
    
        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end
    
      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index
    
        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end
  
    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index
  
        expect(Video.search("whatever").records.to_a).to eq []
      end
  
      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index
  
        expect(Video.search("").records.to_a).to eq []
      end
  
      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index
  
        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end
  
      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index
  
        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end
    
    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index
    
        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end
    
    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index
    
        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
    
    context "filter with average ratings" do
      let(:star_wars_1) { Fabricate(:video, title: "Star Wars 1") }
      let(:star_wars_2) { Fabricate(:video, title: "Star Wars 2") }
      let(:star_wars_3) { Fabricate(:video, title: "Star Wars 3") }
      let(:dan) { Fabricate(:user) }
      let(:katie) { Fabricate(:user) }
    
      before do
        Fabricate(:review, stars: "2", video: star_wars_1, user: dan)
        Fabricate(:review, stars: "4", video: star_wars_1, user: katie)
        Fabricate(:review, stars: "4", video: star_wars_2)
        Fabricate(:review, stars: "2", video: star_wars_3)
        refresh_index
      end
    
      context "with only rating_from" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "4.1").records.to_a).to eq []
        end
    
        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "4.0").records.to_a).to eq [star_wars_2]
        end
    
        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "3.0").records.to_a).to match_array [star_wars_2, star_wars_1]
        end
      end
    
      context "with only rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_to: "1.5").records.to_a).to eq []
        end
    
        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_to: "2.5").records.to_a).to eq [star_wars_3]
        end
    
        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_to: "3.4").records.to_a).to match_array [star_wars_1, star_wars_3]
        end
      end
    
      context "with both rating_from and rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Video.search("Star Wars", rating_from: "3.4", rating_to: "3.9").records.to_a).to eq []
        end
    
        it "returns an array of one video when there is one match" do
          expect(Video.search("Star Wars", rating_from: "1.8", rating_to: "2.2").records.to_a).to eq [star_wars_3]
        end
    
        it "returns an array of many videos when there are multiple matches" do
          expect(Video.search("Star Wars", rating_from: "2.9", rating_to: "4.1").records.to_a).to match_array [star_wars_1, star_wars_2]
        end
      end
    end
  end
end