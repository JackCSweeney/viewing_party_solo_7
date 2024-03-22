require 'rails_helper'

RSpec.describe Movie do
  before(:each) do
    movie_data = {title: "This Movie", 
    vote_average: 6.5, 
    id: 1, 
    runtime: 94, 
    genres: [
      {id: 4, name: "Action"}, 
      {id: 3, name: "Comedy"}
    ], 
    overview: "Funny guys doing action stuff", 
    cast: [
      {"adult": false,
      "gender": 2,
      "id": 70851,
      "known_for_department": "Acting",
      "name": "Jack Black",
      "original_name": "Jack Black",
      "popularity": 81.123,
      "profile_path": "/rtCx0fiYxJVhzXXdwZE2XRTfIKE.jpg",
      "cast_id": 1,
      "character": "Po (voice)",
      "credit_id": "62fae24c303c85008229904c",
      "order": 0},
      {"adult": false,
      "gender": 2,
      "id": 70851,
      "known_for_department": "Acting",
      "name": "Jack White",
      "original_name": "Jack White",
      "popularity": 81.123,
      "profile_path": "/rtCx0fiYxJVhzXXdwZE2XRTfIKE.jpg",
      "cast_id": 1,
      "character": "Bo (voice)",
      "credit_id": "62fae24c303c85008229904c",
      "order": 0}
    ],
    total_results: 1,
    results: [{
      "author": "Chris Sawin",
      "author_details": {
        "name": "Chris Sawin",
        "username": "ChrisSawin",
        "avatar_path": "null",
        "rating": 6
      },
      "content": "_Kung Fu Panda 4_ isn’t the best _Kung Fu Panda_ film, or even the best of the series’ three sequels. However, as a fourth film in a franchise, it’s a ton of fun.\r\n\r\nAnd though it’s action isn’t quite as entertaining as its predecessors and it’s unfortunate to see Awkwafina playing yet another thief (_Jumanji: The Next Level_ says hello), for the most part, _Kung Fu Panda 4_ happily skadooshes its way to animated greatness.\r\n\r\n**Full review:** https://bit.ly/KuFuPa4",
      "created_at": "2024-03-13T13:23:41.755Z",
      "id": "65f1a8ddfa4046012e1121b6",
      "updated_at": "2024-03-13T13:23:41.909Z",
      "url": "https://www.themoviedb.org/review/65f1a8ddfa4046012e1121b6"
      }],
      purchase_image_paths: ["here", "there"],
      rental_image_paths: ["yonder", "hither"],
      poster_path: "somewhere else",
      release_date: "3/2/43"
    }

    @movie = Movie.new(movie_data)
  end

  it 'exists' do
    expect(@movie).to be_a(Movie)
    expect(@movie.title).to eq("This Movie")
    expect(@movie.vote_average).to eq(6.5)
    expect(@movie.id).to eq(1)
    expect(@movie.runtime).to eq(94)
    expect(@movie.genres).to eq(["Action", "Comedy"])
    expect(@movie.description).to eq("Funny guys doing action stuff")
    expect(@movie.cast).to eq({"Po (voice)"=>"Jack Black", "Bo (voice)"=>"Jack White"})
    expect(@movie.review_count).to eq(1)
    expect(@movie.reviewers).to eq({"Chris Sawin"=>"ChrisSawin"})
    expect(@movie.purchase_image_paths).to eq(["here", "there"])
    expect(@movie.rental_image_paths).to eq(["yonder", "hither"])
    expect(@movie.poster_path).to eq("somewhere else")
    expect(@movie.release_date).to eq("3/2/43")
  end

  it 'can return just the names of the genres in an array' do
    expect(@movie.genres).to eq(["Action", "Comedy"])
  end

  it 'can return the cast members and their character names as a hash' do
    expect(@movie.cast).to eq({"Po (voice)"=>"Jack Black", "Bo (voice)"=>"Jack White"})
  end

  it 'can return the reviewers names and their user names as key value pairs in a hash' do
    expect(@movie.reviewers).to eq({"Chris Sawin"=>"ChrisSawin"})
  end
end