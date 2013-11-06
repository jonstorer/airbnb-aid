class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  def sign_in(user)
    session[:user_id] = user.id
    cookies[:remember_me_token] = { :value => user.remember_me_token, :expires => 2.weeks.from_now }
    @current_user = user
  end

  def sign_out
    session.delete(:user_id)
    cookies.delete(:remember_me_token)
    @current_user = nil
  end

  def current_user
    @current_user ||= session[:user_id].present? ? User.find(session[:user_id]) : nil
  end
  helper_method :current_user
end
