require 'rails_helper'

RSpec.describe 'ViewingParties Show Page', type: :feature do
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

      fill_in "duration", with: 98
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      fill_in("guest_email_1", with: "jack@email.com")
      click_on "Create Viewing Party"

    end

    it 'can display the logos of where the movie can be purchased, where it can be rented, and the data attribution for the JustWatch platform' do
      # As a user, 
      # When I visit a Viewing Party's show page (`/users/:user_id/movies/:movie_id/viewing_party/:id`), 
      visit user_movie_viewing_party_path(@user_1.id, 1011985, @user_1.viewing_parties.first.id)
      # I should see 
      # - logos of video providers for where to buy the movie (e.g. Apple TV, Vudu, etc.)
      within ".where_to_buy" do
        expect(page).to have_css()
      end
      # - logos of video providers for where to rent the movie (e.g. Amazon Video, DIRECTV, etc.)
      within ".where_to_rent" do
        expect(page).to have_css()
      end
      # And I should see a data attribution for the JustWatch platform that reads: 
      # "Buy/Rent data provided by JustWatch",
      # as per TMDB's instructions.
      expect(page).to have_content("Buy/Rent data provided by JustWatch")  
    end
  end
end