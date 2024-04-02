class SessionsController < ApplicationController

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}"
      redirect_to user_path(user)
    else
      flash[:error] = "Incorrect email or password"
      render :login_form
    end
  end

  def login_form   
  end

  def destroy
    session.destroy
    redirect_to root_path
  end

end