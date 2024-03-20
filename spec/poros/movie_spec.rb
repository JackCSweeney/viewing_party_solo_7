require 'rails_helper'

RSpec.describe Movie do
  it 'exists' do
    movie_data = {title: "This Movie", vote_average: 6.5, id: 1}

    movie = Movie.new(movie_data)

    expect(movie).to be_a(Movie)
    expect(movie.title).to eq("This Movie")
    expect(movie.vote_average).to eq(6.5)
    expect(movie.id).to eq(1)
  end
end