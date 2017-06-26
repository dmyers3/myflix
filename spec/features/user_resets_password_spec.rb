require 'spec_helper'

feature "User resets password" do
  scenario "user resets password with valid email" do
    dan = Fabricate(:user, password: 'old_password')

    visit login_path
    click_link "Forgot your password?"
    fill_in 'Email Address', with: dan.email
    click_button 'Send Email'
    
    open_email(dan.email)
    current_email.click_link("Reset My Password")
    expect(page).to have_content("Reset Your Password")
    
    fill_in "New Password", with: "new_password"
    click_button "Reset Password"
    
    fill_in "Email Address", with: dan.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"
    
    expect(page).to have_content("Welcome, #{dan.full_name}")
    
    
  end
end