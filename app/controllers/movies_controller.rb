class MoviesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @facade = MovieSearchFacade.new(params[:search])
  end

  def show
    @user = User.find(params[:user_id])
    @facade = MovieFacade.new(params[:id])
  end

end