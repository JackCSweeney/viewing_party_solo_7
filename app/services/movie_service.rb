class MovieService
  
  def conn
    conn = Faraday.new(url: "https://api.themoviedb.org") do |f|
      f.params["api_key"] = Rails.application.credentials.tmdb[:key]
    end
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def complete_movie_data(movie_id)
    details_data = get_url("/3/movie/#{movie_id}?language=en-US")
    credits_data = get_url("/3/movie/#{movie_id}/credits?language=en-US")
    review_data = get_url("/3/movie/#{movie_id}/reviews?language=en-US&page=1")

    review_data.merge(credits_data.merge(details_data))
  end

end