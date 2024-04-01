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
      expect(page).to have_field("user_email")
      expect(page).to have_field("user_password")
      # When I enter my unique email and correct password
      fill_in "user_email", with: @user_1.email
      fill_in "user_password", with: @user_1.password
      click_on "Log In"
      # I'm taken to my dashboard page
      expect(current_path).to eq(user_path(@user_1))
    end
  end
end