class MovieSearchFacade

  def initialize(search_param)
    @search_param = search_param
  end

  def movies
    if @search_param == "top_rated"
      conn = Faraday.new(url: "https://api.themoviedb.org") do |f|
        f.params["api_key"] = Rails.application.credentials.tmdb[:key]
      end

      response = conn.get("/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")
      
      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results].map do |movie_data|
        Movie.new(movie_data)
      end
    else
      conn = Faraday.new(url: "https://api.themoviedb.org") do |f|
        f.params["api_key"] = Rails.application.credentials.tmdb[:key]
      end

      response = conn.get("/3/search/movie?query=#{@search_param}&include_adult=false&include_video=false&language=en-US&page=1")

      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results].map do |movie_data|
        Movie.new(movie_data)
      end
    end
  end
end