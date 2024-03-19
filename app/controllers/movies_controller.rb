class MoviesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    if params[:search]
      conn = Faraday.new(url: "https://api.themoviedb.org/3/search/movie") do |f|
        f.params["api_key"] = Rails.application.credentials.tmdb[:key]
      end

      response = conn.get("?query=#{params[:search]}&include_adult=false&include_video=false&language=en-US&page=1")

      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results].map do |movie_data|
        Movie.new(movie_data)
      end
    else
      conn = Faraday.new(url: "https://api.themoviedb.org/3/discover/movie") do |f|
        f.params["api_key"] = Rails.application.credentials.tmdb[:key]
      end

      response = conn.get("?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc")
      
      json = JSON.parse(response.body, symbolize_names: true)
      @movies = json[:results].map do |movie_data|
        Movie.new(movie_data)
      end
    end
  end

end