class MovieFacade

  def initialize(movie_id = '')
    @movie_id = movie_id
  end

  def movie
    service = MovieService.new

    json = service.complete_movie_data(@movie_id)

    @movie = Movie.new(json)
  end

  def where_to_buy
    service = MovieService.new
    service.movie_purchase_location_logos(@movie_id)
  end

  def where_to_rent
    service = MovieService.new
    service.movie_rental_location_logos(@movie_id)
  end

  def similar_movies
    service = MovieService.new
    json = service.get_similar_movies(@movie_id)
    json[:results].map do |movie_data|
      Movie.new(movie_data)
    end
  end

  def viewing_party_movie(movie_id)
    service = MovieService.new
    json = service.complete_movie_data(movie_id)
    Movie.new(json)
  end
end