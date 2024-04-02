require 'rails_helper'

RSpec.describe 'User Sessions' do
  before(:each) do
    @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")

    visit "/"
    click_on "Log In"
    fill_in "email", with: @user_1.email
    fill_in "password", with: @user_1.password
    click_on "Log In"
  end

  it 'can stay logged in after navigating away from page' do
    # As a user when I log in successfully
    # and then leave the website and navigate to a different website entirely,
    visit "https://www.google.com"
    # Then when I return to *this* website,
    visit "/" 
    # I see that I am still logged in.
    expect(page).to have_content("Welcome, #{@user_1.name}!")
    expect(page).not_to have_link("Log In", href: "/login")
  end
end