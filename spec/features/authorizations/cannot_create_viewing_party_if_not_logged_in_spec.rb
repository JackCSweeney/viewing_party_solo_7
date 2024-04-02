require 'rails_helper'

RSpec.describe "Create a Viewing Party" do
  describe "As a visitor" do
    before(:each) do
      json_response = File.read("spec/fixtures/kfp_reviews.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/reviews?language=en-US&page=1").
        with(
          query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
          }).to_return(status: 200, body: json_response, headers: {})

      json_response = File.read("spec/fixtures/kfp_credits.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/credits?language=en-US").
        with(
          query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
          }).to_return(status: 200, body: json_response, headers: {})

      json_response = File.read("spec/fixtures/kfp_details.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/1011985?language=en-US").
        with(
          query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
          }).to_return(status: 200, body: json_response, headers: {})
      
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")
      
      visit user_movie_path(@user_1, 1011985)
    end

    it 'will be told to create an account or login when trying to create a viewing party while not logged in' do
      click_on "Create Viewing Party"

      expect(current_path).to eq(user_movie_path(@user_1, 1011985))
      expect(page).to have_content("You must be logged in or registered to create a Viewing Party")
    end
  end
end