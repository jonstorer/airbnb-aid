class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.where(:email => params[:user][:email]).first
    sign_in user
    redirect_to dashboard_path
  end
end
