class Movie

  attr_reader :title,
              :vote_average,
              :id,
              :runtime,
              :description,
              :review_count,
              :purchase_image_paths,
              :rental_image_paths,
              :poster_path,
              :release_date

  def initialize(movie_data)
    @title = movie_data[:title]
    @vote_average = movie_data[:vote_average]
    @id = movie_data[:id]
    @runtime = movie_data[:runtime]
    @genres = movie_data[:genres]
    @description = movie_data[:overview]
    @cast = movie_data[:cast]
    @review_count = movie_data[:total_results]
    @reviewers = movie_data[:results]
    @purchase_image_paths = movie_data[:purchase_image_paths]
    @rental_image_paths = movie_data[:rental_image_paths]
    @poster_path = movie_data[:poster_path]
    @release_date = movie_data[:release_date]
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