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

    it 'can click on either the discover top rated movies button or fill out the search field with a movie title and search then be brought ' do
      # When I visit the discover movies page ('/users/:id/discover'),
      # and click on either the Discover Top Rated Movies button or fill out the movie title search and click the Search button,
      click_on "Discover Top Rated Movies"
      # I should be taken to the movies results page (`users/:user_id/movies`) where I see: 
      expect(current_path).to eq("/users/#{@user_1.id}/movies")
      # - Title (As a Link to the Movie Details page (see story #3))
      # - Vote Average of the movie
      within(".movies") do
        counter = 1
        20.times do
          within("#movie_#{counter}") do
            expect(page).to have_css(".title")
            expect(page).to have_css(".vote_average")
            counter += 1
          end
        end
      end
      # I should also see a button to return to the Discover Page.
      expect(page).to have_button("Return to Discover", href: user_discover_index_path(@user_1))

      visit user_discover_index_path(@user_1)

      fill_in "search", with: "Titanic"
      click_on "Search by Movie Title"

      expect(current_path).to eq("/users/#{@user_1.id}/movies")

      expect(page).to have_css(".title", count: 1)
      expect(page).to have_css(".vote_average", count: 1)
      expect(page).to have_button("Return to Discover", href: user_discover_index_path(@user_1))
    end
  end
end