require 'rails_helper'

RSpec.describe 'Users Show Page', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")
      @user_2 = User.create!(name: 'Jack', email: 'jack@email.com', password: "password1", password_confirmation: "password1")

      json_response = File.read("spec/fixtures/kfp_reviews.json")

        stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/reviews?language=en-US&page=1").
          with(
            query: {
            'api_key'=> Rails.application.credentials.tmdb[:key]
            }).
          to_return(status: 200, body: json_response, headers: {})

      json_response = File.read("spec/fixtures/kfp_credits.json")

        stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/credits?language=en-US").
          with(
            query: {
            'api_key'=> Rails.application.credentials.tmdb[:key]
            }).
          to_return(status: 200, body: json_response, headers: {})

      json_response = File.read("spec/fixtures/kfp_details.json")

        stub_request(:get, "https://api.themoviedb.org/3/movie/1011985?language=en-US").
          with(
            query: {
            'api_key'=> Rails.application.credentials.tmdb[:key]
            }).
          to_return(status: 200, body: json_response, headers: {})

      visit root_path
      click_on "Log In"
      fill_in "email", with: @user_1.email
      fill_in "password", with: @user_1.password
      click_on "Log In"

      visit new_user_movie_viewing_party_path(@user_1, 1011985)
      fill_in "duration", with: 98
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      fill_in("guest_email_1", with: "jack@email.com")
      click_on "Create Viewing Party"

      visit new_user_movie_viewing_party_path(@user_2, 1011985)
      fill_in "duration", with: 98
      fill_in "date", with: "4/5/24"
      fill_in "start_time", with: "6:00PM"
      fill_in("guest_email_1", with: "tommy@email.com")
      click_on "Create Viewing Party"
    end

    it 'can visit the user dashboard and see movie info for all viewing parties, both ones that the user is hosting and that they are invited to' do
      # As a user, When I visit a user dashboard ('/user/:user_id'),
      visit user_path(@user_1)
      # I should see the viewing parties that the user has been invited to with the following details:
      within ".guest" do
        # - Movie Image
        expect(page).to have_css("img")
        # - Date and Time of Event
        expect(page).to have_content("4/5/24 at 6:00PM")
        # - who is hosting the event
        expect(page).to have_content("Host: Jack")
        # - list of users invited, with my name in bold
        expect(page).to have_content("Tommy Jack")
        expect(find(:css, ".bold_user").text).to have_content("Tommy")
        # - Movie Title, which links to the movie show page
        expect(page).to have_content("Kung Fu Panda 4")
        click_on "Kung Fu Panda 4"
      end
      expect(current_path).to eq(user_movie_path(@user_1, 1011985))


      # I should also see the viewing parties that the user has created (hosting) with the following details:
      visit user_path(@user_1)
      within ".host" do
        expect(page).to have_link("Kung Fu Panda 4", href: user_movie_path(@user_1, 1011985))
        # - Movie Image
        expect(page).to have_css("img")
        # - Date and Time of Event
        expect(page).to have_content("4/4/24 at 5:00PM")
        # - who is hosting the event
        expect(page).to have_content("Host: Tommy")
        # - list of users invited, with my name in bold
        expect(page).to have_content("Who's Coming?\nTommy Jack")
      end
    end
  end
end