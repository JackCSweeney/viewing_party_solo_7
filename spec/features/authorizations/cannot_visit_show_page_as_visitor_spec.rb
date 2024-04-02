require 'rails_helper'

RSpec.describe "User Show Page" do
  describe "As a visitor" do
    it 'cannot visit a users show page without being logged in' do
      @user = User.create!(name: 'Sam', email: 'sam_t@email.com', password: "password1", password_confirmation: "password1")

      visit "/users/#{@user.id}"

      expect(current_path).to eq("/")
      expect(page).to have_content("You must be logged in or registered to access a user's dashboard")
    end
  end
end