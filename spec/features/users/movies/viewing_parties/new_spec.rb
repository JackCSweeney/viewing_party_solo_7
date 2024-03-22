require 'rails_helper'

RSpec.describe 'Viewing Party New', type: :feature do
  describe 'As a user' do
    before(:each) do
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

      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com')
      @user_2 = User.create!(name: 'Jack', email: 'jack@email.com')

      visit new_user_movie_viewing_party_path(@user_1, 1011985)
    end

    it 'can visit the new viewing party page to create a viewing party with the duration of the party, date it is happening, the start time, optional guests email address, and a button to create the party' do
      # When I visit the new viewing party page ('/users/:user_id/movies/:movie_id/viewing_party/new', where :user_id is a valid user's id and :movie_id is a valid Movie id from the API),
      # I should see the name of the movie title rendered above a form with the following fields:
      expect(page).to have_content("New Viewing Party for: Kung Fu Panda 4")
      # - Duration of Party with a default value of movie runtime in minutes; a viewing party should NOT be created if set to a value less than the duration of the movie
      expect(page).to have_field("duration")
      # - When: field to select date
      expect(page).to have_field("date")
      # - Start Time: field to select time
      expect(page).to have_field("start_time")
      # - Guests: three (optional) text fields for guest email addresses
      expect(page).to have_field("guest_email_1")
      expect(page).to have_field("guest_email_2")
      expect(page).to have_field("guest_email_3")
      # - Button to create a party
      expect(page).to have_button("Create Viewing Party")    
    end

    it 'cannot make a viewing party with a duration that is shorter than the movie run time' do
      fill_in "duration", with: 90
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      click_on "Create Viewing Party"

      expect(current_path).to eq(new_user_movie_viewing_party_path(@user_1, 1011985))
      expect(page).to have_content("Duration cannot be shorter than movie runtime")
    end

    it 'can create a viewing party and be taken back to the users index page and see the newly created viewing party' do
      fill_in "duration", with: 98
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      fill_in("guest_email_1", with: "jack@email.com")
      click_on "Create Viewing Party"

      expect(current_path).to eq(user_path(@user_1))
      expect(page).to have_content("Home\nTommy's Dashboard\nParty Time: 4/4/24 at 5:00PM Host: Tommy Who's Coming?\nTommy Jack")
    end

    it 'will show the viewing party on the index of page of guests that were invited to the party' do
      fill_in "duration", with: 98
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      fill_in("guest_email_1", with: "jack@email.com")
      click_on "Create Viewing Party"

      visit user_path(@user_2)

      expect(page).to have_content("Home\nJack's Dashboard\nParty Time: 4/4/24 at 5:00PM Host: Tommy Who's Coming?\nTommy Jack")
    end
  end
end