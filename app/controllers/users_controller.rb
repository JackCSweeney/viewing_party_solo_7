class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @facade = MovieFacade.new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = 'Successfully Created New User'
      redirect_to user_path(user)
    else
      flash[:error] = "#{error_message(user.errors)}"
      redirect_to register_user_path
    end   
  end

  def login_form
  end

  def login
    # should move this to some sort of error handling/rescue clause to keep controller lighter
    if user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        redirect_to user_path(user)
      else
        render :login_form
        flash[:error] = "Incorrect email or password"
      end
    else
      render :login_form
      flash[:error] = "Incorrect email or password"
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end