class MoviesController < ApplicationController

  def index
    if params[:search]

    else
      conn = Faraday.new(url: "https://api.themoviedb.org/3/discover/movie") do |f|
        f.params["api_key"] = Rails.application.credentials.tmdb[:key]
      end

      response = conn.get("?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")
      
      data = JSON.parse(response.body, symbolize_names: true)
      @movies = data[:results]
    end
  end

end