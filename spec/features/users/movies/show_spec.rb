require 'rails_helper'

RSpec.describe 'Movies Show Page', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com', password: "password1", password_confirmation: "password1")

      visit root_path
      click_on "Log In"
      fill_in "email", with: @user_1.email
      fill_in "password", with: @user_1.password
      click_on "Log In"

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
          
      json_response = File.read("spec/fixtures/kfp_similar.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/similar").
        with(
        query: {
            'api_key'=> Rails.application.credentials.tmdb[:key]
        }).
        to_return(status: 200, body: json_response, headers: {})
    end

    it 'can display a movies title, vote average, runtime, genres, summary, first 10 cast members,count of reviews, each reviews author and info' do
      VCR.turn_off!
      # As a user, When I visit a movie's detail page (`/users/:user_id/movies/:movie_id`) where :id is a valid user id,
      visit "/users/#{@user_1.id}/movies/1011985"
      # I should see
      # - a button to Create a Viewing Party
      expect(page).to have_button("Create Viewing Party")
      # - a button to return to the Discover Page
      expect(page).to have_button("Return to Discover")
      
      # I should also see the following information about the movie:
      
      # - Movie Title
      expect(page).to have_content("Kung Fu Panda 4")
      # - Vote Average of the movie
      expect(page).to have_content("Average Voter Rating: 6.874")
      # - Runtime in hours & minutes
      expect(page).to have_content("Runtime: 1 hours 34 minutes")
      # - Genre(s) associated to movie
      expect(page).to have_content("Genre(s): Action, Adventure, Animation, Comedy, Family")
      # - Summary description
      expect(page).to have_content("Description: Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.")
      # - List the first 10 cast members (characters & actress/actors)
      expect(page).to have_content("Cast:\nPo (voice) - Jack Black\nZhen (voice) - Awkwafina\nLi (voice) - Bryan Cranston\nThe Chameleon (voice) - Viola Davis\nShifu (voice) - Dustin Hoffman\nMr. Ping (voice) - James Hong\nTai Lung (voice) - Ian McShane\nHan (voice) - Ke Huy Quan\nFish (voice) - Ronny Chieng\nGranny Boar (voice) - Lori Tan Chinn")
      # - Count of total reviews
      expect(page).to have_content("Total Reviews: 1")
      # - Each review's author and information
      expect(page).to have_content("Reviewers:\nAuthor: Chris Sawin - User Name: ChrisSawin")
      
      click_on "Create Viewing Party"
      expect(current_path).to eq(new_user_movie_viewing_party_path(@user_1, 1011985))
    end

    it 'can visit the movie show page and see a link to see similar movies that takes them to a similar movies page and displays title, overvie, release date, poster image, and vote average of other similar movies' do
      VCR.turn_off!
      # As a user, 
      # When I visit a Movie Details page (`/users/:user_id/movies/:movie_id`),
      visit "/users/#{@user_1.id}/movies/1011985"
      # I see a link for "Get Similar Movies"
      expect(page).to have_link("Get Similar Movies", href: user_movie_similar_index_path(@user_1, 1011985))
      # When I click that link
      click_on "Get Similar Movies"
      # I am taken to the Similar Movies page (`/users/:user_id/movies/:movie_id/similar`)
      expect(current_path).to eq(user_movie_similar_index_path(@user_1, 1011985))
      # Where I see a list of movies that are similar to the one provided by :movie_id, 
      # which includes the similar movies': 
      # - Title
      expect(page).to have_css(".title")
      # - Overview
      expect(page).to have_css(".description")
      # - Release Date
      expect(page).to have_css(".release_date")
      # - Poster image
      expect(page).to have_css(".img")
      # - Vote Average
      expect(page).to have_css(".vote_average")
    end
  end
end