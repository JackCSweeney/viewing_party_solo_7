require 'rails_helper'

RSpec.describe "User Cookies" do
  before(:each) do
    @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")
  end 

  it "can store the state input by the user when logging in as a cookie" do
    # As a user when I go to the login page (/login)
    visit login_path
    # Under the normal login fields (username, password)
    # I also see a text input field for "Location"
    expect(page).to have_field("location")
    # When I enter my city and state in this field (e.g. "Denver, CO")
    # and successfully log in
    fill_in "email", with: @user_1.email
    fill_in "password", with: @user_1.password
    fill_in "location", with: "Los Angeles, CA"
    click_on "Log In"
    # I see my location on the landing page as I entered it.
    expect(page).to have_content("Location: Los Angeles, CA")
    # Then, when I log out and return to the login page
    click_on "Log Out"
    click_on "Log In"
    save_and_open_page
    # I still see my location that I entered previously
    # already typed into the Location field. 
    expect(page).to have_field("location", with: "Los Angeles, CA") 
  end
end