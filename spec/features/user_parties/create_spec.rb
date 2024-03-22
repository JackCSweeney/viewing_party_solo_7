require 'rails_helper'

RSpec.describe 'User Parties Create', type: :feature do
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

    it 'can create a user party with the host' do
      fill_in "duration", with: 98
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      click_on "Create Viewing Party"

      user_party = UserParty.find_by(user_id: @user_1.id)

      expect(user_party).to be_a(UserParty)
      expect(user_party.host).to eq(true)
    end

    it 'can create user parties for guests included in the party and will return false if they are not the host' do
      fill_in "duration", with: 98
      fill_in "date", with: "4/4/24"
      fill_in "start_time", with: "5:00PM"
      fill_in("guest_email_1", with: "jack@email.com")
      click_on "Create Viewing Party"

      user_party = UserParty.find_by(user_id: @user_2.id)

      expect(user_party).to be_a(UserParty)
      expect(user_party.host).to eq(false)
    end
  end
end