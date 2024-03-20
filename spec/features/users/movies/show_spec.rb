require 'rails_helper'

RSpec.describe 'Movies Show Page', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com')
    end

    it 'can display a movies title, vote average, runtime, genres, summary, first 10 cast members,count of reviews, each reviews author and info' do
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
      expect(page).to have_content(7.0)
      # - Runtime in hours & minutes
      # - Genre(s) associated to movie
      # - Summary description
      expect(page).to have_content("Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.")
      # - List the first 10 cast members (characters & actress/actors)
      # - Count of total reviews
      # - Each review's author and information      
    end
  end
end