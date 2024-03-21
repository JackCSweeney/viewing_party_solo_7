class MovieSearchFacade

  def initialize(search_param)
    @search_param = search_param
  end

  def movies
    service = MovieSearchService.new

    if @search_param == "top_rated"
      json = service.top_rated_movies

      @movies = json[:results].map do |movie_data|
        Movie.new(movie_data)
      end
    else
      json = service.movies_by_title(@search_param)

      @movies = json[:results].map do |movie_data|
        Movie.new(movie_data)
      end
    end
  end
end