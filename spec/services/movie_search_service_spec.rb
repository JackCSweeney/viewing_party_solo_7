require 'rails_helper'

RSpec.describe MovieSearchService do
  before(:each) do
    json_response = File.read("spec/fixtures/search_by_top_rated.json")

    stub_request(:get, "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc").
    with(
      query: {
        'api_key'=> Rails.application.credentials.tmdb[:key]
      }).
    to_return(status: 200, body: json_response, headers: {})
  end

  describe '#top_rated_movies' do
    it 'returns movie data' do
      top_rated = MovieSearchService.new.top_rated_movies

      expect(top_rated).to be_a(Hash)
      expect(top_rated[:results]).to be_a(Array)
      
      movie_data = top_rated[:results].first

      expect(movie_data).to have_key(:title)
      expect(movie_data[:title]).to be_a(String)
      
      expect(movie_data).to have_key(:vote_average)
      expect(movie_data[:vote_average]).to be_a(Float)
      
      expect(movie_data).to have_key(:id)
      expect(movie_data[:id]).to be_a(Integer)     
    end
  end

  describe '#conn' do
    it 'connects to the correct base URL and contains a api_key' do
      service = MovieSearchService.new

      expect(service.conn).to be_a(Faraday::Connection)
      expect(service.conn.params[:api_key]).not_to be(nil)
    end
  end

  describe '#get_url(url)' do
    it 'returns the parsed JSON data from the get request to the input url' do
      service = MovieSearchService.new

      expect(service.get_url("/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")).to be_a(Hash)
      expect(service.get_url("/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")[:results].first).to have_key(:id)
      expect(service.get_url("/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")[:results].first).to have_key(:title)
      expect(service.get_url("/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")[:results].first).to have_key(:vote_average)
    end
  end

  describe '#movies_by_title(title)' do
    it 'returns movie data' do
      VCR.turn_on!
      VCR.use_cassette("tmdb_title_search") do
        search = MovieSearchService.new.movies_by_title("Titanic")

        expect(search).to be_a(Hash)
        expect(search[:results]).to be_a(Array)
        
        movie_data = search[:results].first

        expect(movie_data).to have_key(:title)
        expect(movie_data[:title]).to be_a(String)
        
        expect(movie_data).to have_key(:vote_average)
        expect(movie_data[:vote_average]).to be_a(Float)
        
        expect(movie_data).to have_key(:id)
        expect(movie_data[:id]).to be_a(Integer)
      end  
      VCR.turn_off!   
    end
  end
end