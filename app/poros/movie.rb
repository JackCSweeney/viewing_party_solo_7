class Movie

  attr_reader :title,
              :vote_average,
              :id,
              :runtime,
              :description,
              :review_count

  def initialize(movie_data)
    @title = movie_data[:title]
    @vote_average = movie_data[:vote_average]
    @id = movie_data[:id]
    @runtime = movie_data[:runtime]
    @genres = movie_data[:genres]
    @description = movie_data[:overview]
    @cast = movie_data[:cast] # this will come in as an array of hashes and each hash will come with some unneeded data so it will have to be broken down somewhere to extract just what is needed
    @review_count = movie_data[:total_results]
    @reviewers = movie_data[:results] # this will come in as a hash with some unneeded data so it will have to be broken down somewhere to extract just what is needed
  end

  def genres
    @genres.map do |genre_hash|
      genre_hash[:name]
    end
  end

  def cast
    cast_hash = {}
    @cast[0..9].each do |cast_member|
      cast_hash[cast_member[:character]] = cast_member[:name]
    end
    cast_hash
  end

  def reviewers
    reviewer_hash = {}
    @reviewers.each do |reviewer|
      reviewer_hash[reviewer[:author_details][:name]] = reviewer[:author_details][:username]
    end
    reviewer_hash
  end

end