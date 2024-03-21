require 'rails_helper'

RSpec.describe 'Viewing Party New', type: :feature do
  describe 'As a user' do
    before(:each) do
      @user_1 = @user_1 = User.create!(name: 'Tommy', email: 'tommy@email.com')
      visit new_user_movie_viewing_party_path(@user_1, 1011985)
    end

    it 'can visit the new viewing party page to create a viewing party with the duration of the party, date it is happening, the start time, optional guests email address, and a button to create the party' do
      # When I visit the new viewing party page ('/users/:user_id/movies/:movie_id/viewing_party/new', where :user_id is a valid user's id and :movie_id is a valid Movie id from the API),
      # I should see the name of the movie title rendered above a form with the following fields:
      expect(page).to have_content("New Viewing Party for: Kung Fu Panda 4")
      # - Duration of Party with a default value of movie runtime in minutes; a viewing party should NOT be created if set to a value less than the duration of the movie
      expect(page).to have_field("party_duration", value: 94)
      # - When: field to select date
      expect(page).to have_field("party_date")
      # - Start Time: field to select time
      expect(page).to have_field("party_date")
      # - Guests: three (optional) text fields for guest email addresses
      expect(page).to have_field("guest_email", count: 3)
      # - Button to create a party
      expect(page).to have_button("Create Viewing Party")    
    end

    it 'cannot make a viewing party with a duration that is shorter than the movie run time' do
      fill_in "party_druation", with: 90
      fill_in "party_date", with: "4/4/24"
      click_on "Create Viewing Party"

      expect(current_path).to eq(new_user_movie_viewing_party_path(@user_1, 1011985))
      expect(page).to have_content("Party Duration cannot be shorter than Movie runtime")
    end

    it 'can create a viewing party and be taken back to the viewing parties index page and see the newly created viewing party' do
      fill_in "party_druation", with: 98
      fill_in "party_date", with: "4/4/24"
      fill_in(first("guest_email")), with: "jack@email.com"
      click_on "Create Viewing Party"

      expect(current_path).to eq(user_movie_viewing_parties_path(@user_1, 1011985))
      expect(page).to have_content("Viewing Party for: Kung Fu Panda 4")
    end
  end
end