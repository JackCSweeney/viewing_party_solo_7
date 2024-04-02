require 'rails_helper'

RSpec.describe 'Root Page, Welcome Index', type: :feature do
  describe "As a Visitor" do
    before(:each) do
      @user_1 = User.create!(name: 'Sam', email: 'sam_t@email.com', password: "password1", password_confirmation: "password1")
      @user_2 = User.create!(name: 'Tommy', email: 'tommy_t@gmail.com', password: "password1", password_confirmation: "password1")

      visit root_path
    end

    it 'visits the home page and does not see a list of existing users' do
      expect(page).not_to have_content("Existing Users")
      expect(page).not_to have_css("#existing_users")
      expect(page).not_to have_content(User.first.email)
      expect(page).not_to have_content(User.last.email)
      expect(page).not_to have_link("#{User.first.email}", href: "users/#{User.first.id}")
      expect(page).not_to have_link("#{User.last.email}", href: "users/#{User.last.id}")
    end

    it 'They see button to create a New User' do
      expect(page).to have_selector(:link_or_button, 'Create New User')
    end
  end
  
  describe 'When a user visits the root path "/"' do
    before(:each) do
      @user_1 = User.create!(name: 'Sam', email: 'sam_t@email.com', password: "password1", password_confirmation: "password1")
      @user_2 = User.create!(name: 'Tommy', email: 'tommy_t@gmail.com', password: "password1", password_confirmation: "password1")

      visit root_path
      click_on "Log In"
      fill_in "email", with: @user_1.email
      fill_in "password", with: @user_1.password
      click_on "Log In"
      visit root_path
    end

    it 'They see title of application, and link back to home page' do
      expect(page).to have_content('Viewing Party')
      expect(page).to have_link('Home')
    end

    it "They see a list of existing users" do
      within("#existing_users") do 
        expect(page).to have_content(User.first.email)
        expect(page).to have_content(User.last.email)
      end   
    end

    it "They see a link to go back to the landing page (present at the top of all pages)" do
      expect(page).to have_link("Home")
    end    
  end
  
end
