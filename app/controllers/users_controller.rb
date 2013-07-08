class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.save
    flash[:notice] = "Thank you for registering! We're updating your account from Airbnb."
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:email, :airbnb_user_id, :password, :password_confirmation)
  end
end