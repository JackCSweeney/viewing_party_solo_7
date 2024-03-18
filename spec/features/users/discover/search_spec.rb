require 'rails_helper'

RSpec.describe 'Movie Search', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com')
    end

    it 'displays a button to discover top rated movies and a text field and button to search movies by title' do
      # As a user, When I visit the '/users/:id/discover' path (where :id is the id of a valid user),
      visit user_discover_index_path(@user_1)
      # I should see
      # - a Button to Discover Top Rated Movies
      expect(page).to have_button("Discover Top Rated Movies")
      # - a text field to enter keyword(s) to search by movie title
      expect(page).to have_field("search")
      # - a Button to Search by Movie Title
      expect(page).to have_button("Search by Movie Title")      
    end
  end
end