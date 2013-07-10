class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.where(:email => params[:user][:email]).first
    if @user.password_matches?(params[:user][:password])
      sign_in @user
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def destroy
    sign_out
    flash[:notice] = "Signed Out"
    redirect_to root_url
  end
end
