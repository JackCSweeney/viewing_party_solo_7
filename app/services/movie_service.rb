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

  def image_conn
    conn = Faraday.new(url: "https://image.tmdb.org") do |f|
      f.params["api_key"] = Rails.application.credentials.tmdb[:key]
    end
  end

  def provider_data(movie_id)
    get_url("/3/movie/#{movie_id}/watch/providers")
  end

  def get_image_url(url)
    response = image_conn.get(url)
    # require 'pry' ; binding.pry
    JSON.parse(response.body)
  end

  def movie_purchase_location_logos(movie_id)
    purchase_logo_urls(movie_id).map do |url|
      get_image_url("/t/p/w500#{url}")
    end
  end

  def movie_rental_location_logos(movie_id)
    rental_logo_urls(movie_id).map do |url|
      get_image_url("/t/p/w500#{url}")
    end
  end

  def purchase_logo_urls(movie_id)
    provider_data(movie_id)[:results][:CA][:buy].map do |provider|
      provider[:logo_path]
    end
  end

  def rental_logo_urls(movie_id)
    provider_data(movie_id)[:results][:CA][:rent].map do |provider|
      provider[:logo_path]
    end
  end

end