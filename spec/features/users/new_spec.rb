require 'rails_helper'

RSpec.describe 'Create New User', type: :feature do
  describe 'When user visits "/register"' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")
      @user_2 = User.create!(name: 'Sam', email: 'sam@email.com', password: "password1", password_confirmation: "password1")

      visit register_user_path
    end
    
    it 'They see a Home link that redirects to landing page' do

      expect(page).to have_link('Home')

      click_link "Home"

      expect(current_path).to eq(root_path)
    end
    
    it 'They see a form to fill in their name, email, password, and password confirmation' do
      expect(page).to have_field("user_name")
      expect(page).to have_field('user_email')
      expect(page).to have_field('user_password')
      expect(page).to have_field('user_password_confirmation')
      expect(page).to have_selector(:link_or_button, 'Create New User')    
    end
    
    it 'When they fill in the form with their name and email then they are taken to their dashboard page "/users/:id"' do
      fill_in "user_name", with: 'Chris'
      fill_in "user_email", with: 'chris@email.com'
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"

      click_button 'Create New User'
    
      new_user = User.last

      expect(current_path).to eq(user_path(new_user))
      expect(page).to have_content('Successfully Created New User')
    end

    it 'when they fill in form with information, email (non-unique), submit, redirects to user show page' do
      fill_in "user[name]", with: 'Tommy'
      fill_in "user[email]", with: 'tommy@email.com'
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"

      click_button 'Create New User'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email has already been taken')
    end

    it 'when they fill in form with missing information' do
      fill_in "user[name]", with: ""
      fill_in "user[email]", with: ""
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"
      click_button 'Create New User'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content("Name can't be blank, Email can't be blank")
    end

    it 'They fill in form with invalid email format (only somethng@something.something)' do 
      fill_in "user[name]", with: "Sam"
      fill_in "user[email]", with: "sam sam@email.co.uk"
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"

      click_button 'Create New User'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')

      fill_in "user[name]", with: "Sammy"
      fill_in "user[email]", with: "sam@email..com"
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"
      click_button 'Create New User'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')

      fill_in "user[name]", with: "Sammy"
      fill_in "user[email]", with: "sam@emailcom."
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"
      click_button 'Create New User'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')

      fill_in "user[name]", with: "Sammy"
      fill_in "user[email]", with: "sam@emailcom@"
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password1"
      click_button 'Create New User'

      expect(current_path).to eq(register_user_path)
      expect(page).to have_content('Email is invalid')
    end

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

    # User Story 2
    it 'will not register a user if the password and password confirmation do not match' do
      # As a visitor When I visit `/register`
      visit '/register'
      # and I fail to fill in my name, unique email, OR matching passwords,
      fill_in 'user_name', with: "Jack"
      fill_in 'user_email', with: "jack@email.com"
      fill_in 'user_password', with: "password1"
      fill_in 'user_password_confirmation', with: "password2"
      click_on 'Create New User'
      # I'm taken back to the `/register` page
      expect(current_path).to eq("/register")
      # and a flash message pops up, telling me what went wrong
      expect(page).to have_content("Password confirmation doesn't match Password")
    end    
  end
end