require 'rails_helper'

RSpec.describe 'Movie Search', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com')

      visit user_discover_index_path(@user_1)
    end

    it 'displays a button to discover top rated movies and a text field and button to search movies by title' do
      # As a user, When I visit the '/users/:id/discover' path (where :id is the id of a valid user),
      # I should see
      # - a Button to Discover Top Rated Movies
      expect(page).to have_button("Discover Top Rated Movies")
      # - a text field to enter keyword(s) to search by movie title
      expect(page).to have_field("search")
      # - a Button to Search by Movie Title
      expect(page).to have_button("Search by Movie Title")      
    end

    it 'can click on the discover top rated movies button and then be brought to the movies index' do
      json_response = File.read("spec/fixtures/search_by_top_rated.json")

      stub_request(:get, "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc").
         with(
           query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
           }).
         to_return(status: 200, body: json_response, headers: {})

      # When I visit the discover movies page ('/users/:id/discover'),
      # and click on either the Discover Top Rated Movies button or fill out the movie title search and click the Search button,
      click_on "Discover Top Rated Movies"
      # I should be taken to the movies results page (`users/:user_id/movies`) where I see: 
      expect(current_path).to eq("/users/#{@user_1.id}/movies")
      expect(page).to have_css(".movie", count: 20)
      # - Title (As a Link to the Movie Details page (see story #3))
      # - Vote Average of the movie
      within(first(".movie")) do
        expect(page).to have_css(".title")
        expect(page).to have_link("Kung Fu Panda", href: "/users/#{@user_1.id}/movies/1011985")
        expect(page).to have_css(".vote_average")
      end
      # I should also see a button to return to the Discover Page.
      expect(page).to have_button("Return to Discover")
    end

    it 'can fill out the search field with a movie title and search then be brought to the movies index with all the movies that fit the keyword search' do
      VCR.use_cassette("tmdb_title_search") do
        visit user_discover_index_path(@user_1)
        
        fill_in "search", with: "Titanic"
        click_on "Search by Movie Title"

        expect(current_path).to eq("/users/#{@user_1.id}/movies")

        expect(page).to have_css(".title")
        expect(page).to have_content("Titanic")
        expect(page).to have_css(".vote_average")
        expect(page).to have_button("Return to Discover")
      end
    end
  end
end