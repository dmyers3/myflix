require 'spec_helper'

feature "Visitor registers and makes payment", js: true, driver: :poltergeist, vcr: true do
  scenario "valid card number and valid user info", js: true, driver: :poltergeist do
    visit register_path
    fill_in "Email Address", with: "danny129@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Dan Myers"
    
    within_frame(find("iframe[title='Secure payment input frame']")) do
      # find("input[name='cardnumber']")
      fill_in 'cardnumber', with: "4242 4242 4242 4242"
      # find("input[name='exp-date']")
      fill_in 'exp-date', with: "10 / 21"
      # find("input[name='cvc']")
      fill_in 'cvc', with: "123"
    end
    
    click_button "Sign Up"
    sleep 5
    
    expect(page).to have_content "Account created!"
    
    
  end
  
  scenario "invalid card number" do
  end
  
  scenario "declined card" do
  end
end