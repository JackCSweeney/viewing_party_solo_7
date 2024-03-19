class MoviesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @facade = MovieFacade.new(params[:search])
  end

end