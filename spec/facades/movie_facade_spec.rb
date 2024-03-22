require 'rails_helper'

RSpec.describe MovieFacade do
  it 'exists' do
    facade = MovieFacade.new("1011985")

    expect(facade).to be_a(MovieFacade)
  end

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

    json_response = File.read("spec/fixtures/titanic_providers.json")

    stub_request(:get, "https://api.themoviedb.org/3/movie/597/watch/providers").
      with(
      query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
      }).
      to_return(status: 200, body: json_response, headers: {})
  
    jpeg_response = File.read("spec/fixtures/response_apple.jpeg")
  
    stub_request(:get, "https://image.tmdb.org/t/p/w500/9ghgSC0MA082EL6HLCW3GalykFD.jpg").
      to_return(status: 200, body: jpeg_response, headers: {})

    json_response = File.read("spec/fixtures/kfp_similar.json")

    stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/similar").
      with(
      query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
      }).
      to_return(status: 200, body: json_response, headers: {})
  end

  it 'can return a movie object with the id it is passed through the initialize method' do            
    facade = MovieFacade.new("1011985")
    
    expect(facade.movie).to be_a(Movie)
  end

  it 'can return an array of logo image paths of rental and purchase locations' do
    VCR.turn_off!
    WebMock.allow_net_connect!
    
    facade = MovieFacade.new(597)

    expect(facade.where_to_buy).to be_a(Array)
    expect(facade.where_to_buy.first).to be_a(String)
    expect(facade.where_to_rent).to be_a(Array)
    expect(facade.where_to_rent.first).to be_a(String)
  end

  it 'can return a list of movies that are similar to the original movie it was made with' do
    facade = MovieFacade.new(1011985)

    expect(facade.similar_movies).to be_a(Array)
    expect(facade.similar_movies.first).to be_a(Movie)
    expect(facade.similar_movies.first.title).not_to eq(nil)
  end
end