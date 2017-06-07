require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    comedies = Fabricate(:category)
    
    lost = Fabricate(:video, title: "Lost", category: comedies)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    friends = Fabricate(:video, title: "Friends", category: comedies)
    sign_in
    find("a[href='/videos/#{lost.id}']").click
    expect(page).to have_content(lost.title)
    
    click_link "+ My Queue"
    expect(page).to have_content(lost.title)
    
    visit video_path(lost)
    expect(page).not_to have_content("+ My Queue")
    
    visit home_path
    find("a[href='/videos/#{monk.id}']").click
    click_link "+ My Queue"
    
    visit home_path
    find("a[href='/videos/#{friends.id}']").click
    click_link "+ My Queue"
    
    fill_in "video_#{lost.id}", with: 3
    fill_in "video_#{monk.id}", with: 1
    fill_in "video_#{friends.id}", with: 2
    
    # if using data-attributes:
    # find("input[data-video-id='#{lost.id}']").set(3)
    
    click_button "Update Instant Queue"
    
    expect(find("#video_#{monk.id}").value).to eq("1")
    expect(find("#video_#{friends.id}").value).to eq("2")
    expect(find("#video_#{lost.id}").value).to eq("3")
    
    
  end
end