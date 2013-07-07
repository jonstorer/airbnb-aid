class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.where(:email => params[:user][:email]).first
    user.password_matches?(params[:user][:password])
    redirect_to dashboard_path
  end
end
