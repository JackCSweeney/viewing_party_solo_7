require 'rails_helper'

RSpec.describe MovieFacade do
  it 'exists' do
    facade = MovieFacade.new("1011985")

    expect(facade).to be_a(MovieFacade)
  end

  it 'can return a movie object with the id it is passed through the initialize method' do
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

    facade = MovieFacade.new("1011985")

    expect(facade.movie).to be_a(Movie)
  end
end