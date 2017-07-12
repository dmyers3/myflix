require 'spec_helper'

feature "Admin adds video" do
  scenario "admin adds new video" do
    comedies = Fabricate(:category)
    
    dan = Fabricate(:admin)
    sign_in(dan)
    
    visit new_admin_video_path
    fill_in "Title", with: "Friends"
    select comedies.name, from: "Category"
    fill_in "Description", with: "Awesome show."
    attach_file "Large cover", "public/uploads/video/large_cover/7/friends_big.jpg"
    attach_file "Small cover", "public/uploads/video/small_cover/7/friends_small.jpg"
    fill_in "Video URL", with: "https://s3.amazonaws.com/myflixdmyers3/videos/Top+15+Funniest+Friends+Moments.mp4"
    click_button "Add Video"
    
    sign_out
    sign_in
    
    visit video_path(Video.first)
    expect(page).to have_content "Friends"
    expect(page).to have_content "Rate this video"
    expect(page).to have_selector("a[href='https://s3.amazonaws.com/myflixdmyers3/videos/Top+15+Funniest+Friends+Moments.mp4']")
  end
end