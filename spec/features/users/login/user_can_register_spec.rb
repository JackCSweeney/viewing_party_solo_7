require 'rails_helper'

RSpec.describe 'User Registration Form' do
  describe 'As a visitor' do
    # User Story 1
    it 'can register a new user from the registration path' do
      # As a visitor When I visit `/register`
      visit '/register'
      # I see a form to fill in my name, email, password, and password confirmation.
      expect(page).to have_field('user_name')
      expect(page).to have_field('user_email')
      expect(page).to have_field('user_password')
      expect(page).to have_field('user_password_confirmation')
      # When I fill in that form with my name, email, and matching passwords,
      fill_in 'user_name', with: "Jack"
      fill_in 'user_email', with: "jack@email.com"
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"
      click_on 'Create New User'
      # I'm taken to my dashboard page `/users/:id`
      id = User.last.id
      expect(current_path).to eq("/users/#{id}")
    end
  end
end
