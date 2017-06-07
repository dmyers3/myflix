require 'spec_helper'

feature "Signing in" do
  background do
    @dan = Fabricate(:user)
  end
  
  scenario "Signing in with correct credentials" do
    sign_in(@dan)
    expect(page).to have_content @dan.full_name
  end
end
