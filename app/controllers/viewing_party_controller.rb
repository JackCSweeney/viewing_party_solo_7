class ViewingPartyController < ApplicationController
  def index
  end

  def new
    @user = User.find(params[:user_id])
    @movie_facade = MovieFacade.new(params[:movie_id])
  end

  def create
    viewing_party = ViewingParty.new(host_viewing_party_params)
    if viewing_party.save
      viewing_party.make_user_parties(params[:user_id])
      redirect_to user_path(params[:user_id])
    else
      flash[:error] = "#{error_message(viewing_party.errors)}"
      redirect_to new_user_movie_viewing_party_path(params[:user_id], params[:movie_id])
    end
  end

  def show
  end

  private
    def host_viewing_party_params
      params.permit(:duration,
                    :date,
                    :start_time,
                    :movie_id,
                    :movie_duration,
                    :guest_email_1,
                    :guest_email_2,
                    :guest_email_3)
    end
end