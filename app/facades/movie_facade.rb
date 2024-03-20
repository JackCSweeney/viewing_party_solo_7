class MovieFacade

  def initialize(movie_id)
    @movie_id = movie_id
  end

  def movie
    conn = Faraday.new(url: "https://api.themoviedb.org") do |f|
      f.params["api_key"] = Rails.application.credentials.tmdb[:key]
    end

    response_1 = conn.get("/3/movie/#{@movie_id}/reviews?language=en-US&page=1")
    response_2 = conn.get("/3/movie/#{@movie_id}/credits?language=en-US")
    response_3 = conn.get("/3/movie/#{@movie_id}?language=en-US")

    json_1 = JSON.parse(response_1.body, symbolize_names: true)
    json_2 = JSON.parse(response_2.body, symbolize_names: true)
    json_3 = JSON.parse(response_3.body, symbolize_names: true)

    json = json_1.merge(json_2.merge(json_3))

    @movie = Movie.new(json)
  end
end