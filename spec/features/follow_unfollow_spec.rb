require 'spec_helper'

# - log in
# home page
# click on video_title
# click on review
# on user profile page follow user
# click people link
#   person should be in list
# then unfollow
#   person should no longer be in list

feature "User follows and unfollows another user" do
  scenario "user follows another user then unfollows" do
    dan = Fabricate(:user)
    katie = Fabricate(:user)
    comedies = Fabricate(:category)
    lost = Fabricate(:video, category: comedies)
    lost_review = Fabricate(:review, user: katie, video: lost)
    
    sign_in(dan)
    find("a[href='/videos/#{lost.id}']").click
    
    click_link katie.full_name
    click_link "Follow"
    
    expect(page).to have_content "People I Follow"
    expect(page).to have_content katie.full_name
    
    find("a[href='/relationships/#{Relationship.first.id}']").click
    expect(page).not_to have_content katie.full_name
  end
end