require 'rails_helper'

RSpec.describe MovieSearchFacade do
  it 'exists' do
    facade = MovieSearchFacade.new("top_rated")

    expect(facade).to be_a(MovieSearchFacade)
  end

  it 'can create movie objects from the string that is input during its instantiation and makes the correct API call when doing so and only returns 20 movies' do
    VCR.use_cassette("tmdb_title_search") do
      facade = MovieSearchFacade.new("Titanic")
      movies = facade.movies

      expect(movies.all?(Movie)).to eq(true)
      expect(movies.count).to eq(20)
    end

    VCR.use_cassette("tmdb_popularity_search") do
      facade = MovieSearchFacade.new("top_rated")
      movies = facade.movies

      expect(movies.all?(Movie)).to eq(true)
      expect(movies.count).to eq(20)
    end
  end
end