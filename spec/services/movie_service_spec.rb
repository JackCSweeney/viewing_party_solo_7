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

    json_response = File.read("spec/fixtures/titanic_providers.json")

    stub_request(:get, "https://api.themoviedb.org/3/movie/597/watch/providers").
    with(
      query: {
        'api_key'=> Rails.application.credentials.tmdb[:key]
      }).
    to_return(status: 200, body: json_response, headers: {})

    jpeg_response = File.read("spec/fixtures/response_apple.jpeg")

    stub_request(:get, "https://image.tmdb.org/t/p/w500/9ghgSC0MA082EL6HLCW3GalykFD.jpg").
    with(
      query: {
        'api_key'=> Rails.application.credentials.tmdb[:key]
      }).
    to_return(status: 200, body: jpeg_response, headers: {})

    json_response = File.read("spec/fixtures/kfp_similar.json")

    stub_request(:get, "https://api.themoviedb.org/3/movie/1011985/similar").
      with(
      query: {
          'api_key'=> Rails.application.credentials.tmdb[:key]
      }).
      to_return(status: 200, body: json_response, headers: {})

    @service = MovieService.new
  end
  
  describe 'complete_movie_data(movie_id)' do
    it 'returns movie data about the movie associated with the give movie_id' do
      expect(@service.complete_movie_data(1011985)).to be_a(Hash)
      expect(@service.complete_movie_data(1011985)[:results]).to be_a(Array)
      
      movie_data = @service.complete_movie_data(1011985)

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
      expect(@service.conn).to be_a(Faraday::Connection)
      expect(@service.conn.params[:api_key]).not_to be(nil)
    end
  end

  describe '#get_url(url)' do
    it 'returns the parsed JSON data from the get request to the input url' do
      # Reviews End Point
      expect(@service.get_url("https://api.themoviedb.org/3/movie/1011985/reviews?language=en-US&page=1")).to be_a(Hash)
      
      # Credits End Point
      expect(@service.get_url("https://api.themoviedb.org/3/movie/1011985/credits?language=en-US")).to be_a(Hash)

      # Details End Point
      expect(@service.get_url("https://api.themoviedb.org/3/movie/1011985?language=en-US")).to be_a(Hash)
    end
  end

  describe '#movie_purchase_location_logos(movie_id)' do
    it 'returns a hash with image paths for logos to purchase the movie' do
      VCR.turn_off!
      WebMock.allow_net_connect!
      
      expect(@service.movie_purchase_location_logos(597)).to be_a(Array)
      expect(@service.movie_purchase_location_logos(597).first).to be_a(String)
    end
  end

  describe '#provider_data(movie_id)' do
    it 'returns provider data about where to purchase and rent the given movie' do
      expect(@service.provider_data(597)).to be_a(Hash)
      expect(@service.provider_data(597)[:results][:CA]).to be_a(Hash)
      expect(@service.provider_data(597)[:results][:CA][:buy]).to be_a(Array)
      expect(@service.provider_data(597)[:results][:CA][:buy].first).to be_a(Hash)
    end
  end

  describe '#purchase_logo_urls(movie_id)' do
    it 'returns an array of urls of logos of where to purchase the movie' do 
      expect(@service.purchase_logo_urls(597).first).to be_a(String)
    end
  end

  describe '#rental_logo_urls(movie_id)' do
    it 'returns an array of urls of logos of where to purchase the movie' do
      expect(@service.rental_logo_urls(597).first).to be_a(String)
    end
  end

  describe '#get_similar_movies(movie_id)' do
    it 'returns an array of movie data with the needed attributes' do
      expect(@service.get_similar_movies(1011985)[:results]).to be_a(Array)
      expect(@service.get_similar_movies(1011985)[:results].first).to be_a(Hash)
      expect(@service.get_similar_movies(1011985)[:results].first[:title]).not_to eq(nil)
      expect(@service.get_similar_movies(1011985)[:results].first[:overview]).not_to eq(nil)
      expect(@service.get_similar_movies(1011985)[:results].first[:release_date]).not_to eq(nil)
      expect(@service.get_similar_movies(1011985)[:results].first[:poster_path]).not_to eq(nil)
      expect(@service.get_similar_movies(1011985)[:results].first[:vote_average]).not_to eq(nil)
    end
  end
end