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
      expect(page).to have_content("Runtime: 1 hour 34 minutes")
      # - Genre(s) associated to movie
      expect(page).to have_content("Genre(s): Action, Adventure, Animation, Comedy, Family")
      # - Summary description
      expect(page).to have_content("Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past.")
      # - List the first 10 cast members (characters & actress/actors)
      expect(page).to have_content("Cast: Po (voice) - Jack Black, Zhen (voice) - Awkwafina, Li (voice) - Bryan Cranston, The Chameleon (voice) - Viola Davis, Shifu (voice) - Dustin Hoffman, Mr. Ping (voice) - James Hong, Tai Lung (voice) - Ian McShane, Han (voice) - Ke Huy Quan, Fish (voice) - Ronny Chieng, Granny Boar (voice) - Lori Tan Chinn")
      # - Count of total reviews
      expect(page).to have_content("Total Reviews: 1")
      # - Each review's author and information
      expect(page).to have_content("Reviewers:\nAuthor: Chris Swain\nUser Name: ChrisSwain")      
    end
  end
end