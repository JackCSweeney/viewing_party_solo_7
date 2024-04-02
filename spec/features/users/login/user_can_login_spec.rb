require 'rails_helper'

RSpec.describe 'User Login', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")
    end

    # User Story 3
    it 'can log in to the application through the login page' do
      # As a registered user when I visit the landing page `/`
      visit "/"
      # I see a link for "Log In"
      expect(page).to have_link("Log In", href: "/login")
      # When I click on "Log In"
      click_link "Log In"
      # I'm taken to a Log In page ('/login') where I can input my unique email and password.
      expect(current_path).to eq("/login")
      expect(page).to have_field("email")
      expect(page).to have_field("password")
      # When I enter my unique email and correct password
      fill_in "email", with: @user_1.email
      fill_in "password", with: @user_1.password
      click_on "Log In"
      # I'm taken to my dashboard page
      expect(current_path).to eq(user_path(@user_1))
    end

    # User Story 4
    it 'will not log a user in if the credentials given are invalid' do
      # As a registered user when I visit the landing page `/`
      visit "/"
      # And click on the link to go to my dashboard
      click_on "Log In"
      # And fail to fill in my correct credentials 
      fill_in "email", with: @user_1.email
      fill_in "password", with: "badpassword"
      click_on "Log In"
      # I'm taken back to the Log In page
      expect(current_path).to eq(login_path)
      # And I can see a flash message telling me that I entered incorrect credentials. 
      expect(page).to have_content("Incorrect email or password")
    end

    it 'can leave the page after logging in and return to find themselves still logged in' do
      # As a user when I log in successfully
      visit "/"
      click_on "Log In"
      fill_in "email", with: @user_1.email
      fill_in "password", with: @user_1.password
      click_on "Log In"
      # and then leave the website and navigate to a different website entirely,
      visit "https://www.google.com"
      # Then when I return to *this* website,
      visit "/" 
      # I see that I am still logged in.
      expect(page).to have_content("Welcome, #{@user_1.name}!")
    end
  end
end