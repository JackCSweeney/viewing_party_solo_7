require 'rails_helper'

RSpec.describe MovieFacade do
  it 'exists' do
    facade = MovieFacade.new("top_rated")

    expect(facade).to be_a(MovieFacade)
  end

  it 'can create movie objects from the string that is input during its instantiation and makes the correct API call when doing so' do
    VCR.use_cassette("tmdb_title_search") do
      facade = MovieFacade.new("titanic")

      expect(facade.movies.all?(Movie)).to eq(true)
    end

    VCR.use_cassette("tmdb_popularity_search") do
      facade = MovieFacade.new("top_rated")

      expect(facade.movies.all?(Movie)).to eq(true)
    end
  end
end