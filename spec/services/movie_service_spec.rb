require 'rails_helper'

RSpec.describe MovieService do
  describe '#initialize' do
    it 'exists' do
      service = MovieService.new

      expect(service).to be_a(MovieService)
    end
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
  end
  
  describe 'complete_movie_data(movie_id)' do
    it 'returns movie data about the movie associated with the give movie_id' do
      service = MovieService.new

      expect(service.complete_movie_data(1011985)).to be_a(Hash)
      expect(service.complete_movie_data(1011985)[:results]).to be_a(Array)
      
      movie_data = service.complete_movie_data(1011985)

      expect(movie_data).to have_key(:title)
      expect(movie_data[:title]).to be_a(String)
      
      expect(movie_data).to have_key(:vote_average)
      expect(movie_data[:vote_average]).to be_a(Float)
      
      expect(movie_data).to have_key(:id)
      expect(movie_data[:id]).to be_a(Integer) 

      expect(movie_data).to have_key(:genres)
      expect(movie_data[:genres]).to be_a(Array)
      expect(movie_data[:genres].first).to be_a(Hash)

      expect(movie_data).to have_key(:overview)
      expect(movie_data[:overview]).to be_a(String)

      expect(movie_data).to have_key(:cast)
      expect(movie_data[:cast]).to be_a(Array)
      expect(movie_data[:cast].first).to be_a(Hash)

      expect(movie_data).to have_key(:total_results)
      expect(movie_data[:total_results]).to be_a(Integer)

      expect(movie_data).to have_key(:results)
      expect(movie_data[:results]).to be_a(Array)
      expect(movie_data[:results].first).to be_a(Hash)
    end
  end

  describe '#conn' do
    it 'connects to the correct base URL and contains a api_key' do
      service = MovieService.new

      expect(service.conn).to be_a(Faraday::Connection)
      expect(service.conn.params[:api_key]).not_to be(nil)
    end
  end

  describe '#get_url(url)' do
    it 'returns the parsed JSON data from the get request to the input url' do
      service = MovieSearchService.new

      # Reviews End Point
      expect(service.get_url("https://api.themoviedb.org/3/movie/1011985/reviews?language=en-US&page=1")).to be_a(Hash)
      
      # Credits End Point
      expect(service.get_url("https://api.themoviedb.org/3/movie/1011985/credits?language=en-US")).to be_a(Hash)

      # Details End Point
      expect(service.get_url("https://api.themoviedb.org/3/movie/1011985?language=en-US")).to be_a(Hash)
    end
  end
end