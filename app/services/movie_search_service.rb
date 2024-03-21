class MovieSearchService

  def conn
    conn = Faraday.new(url: "https://api.themoviedb.org") do |f|
      f.params["api_key"] = Rails.application.credentials.tmdb[:key]
    end

  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def top_rated_movies
    get_url("/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")
  end

end