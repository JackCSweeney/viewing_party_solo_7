class MovieFacade

  def initialize(movie_id)
    @movie_id = movie_id
  end

  def movie
    service = MovieService.new

    json = service.complete_movie_data(@movie_id)

    @movie = Movie.new(json)
  end

  def where_to_buy
    service = MovieService.new
    where_to_buy = service.movie_purchase_location_logos(@movie_id)
  end

  def where_to_rent
    service = MovieService.new
    where_to_buy = service.movie_rental_location_logos(@movie_id)
  end
end