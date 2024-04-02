require 'rails_helper'

RSpec.describe "User Log Out" do
  describe "As a User" do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")

      visit login_path
      fill_in "email", with: @user_1.email
      fill_in "password", with: @user_1.password
      click_on "Log In"
    end

    it 'can successfully log out of the application' do
      visit root_path

      expect(page).to have_link("Log Out", href: root_path)

      click_on "Log Out"

      expect(current_path).to eq(root_path)
      expect(page).not_to have_content("Welcome, #{@user_1.name}!")
      expect(page).to have_link("Log In")
      expect(page).to have_button("Create New User")
    end
  end
end