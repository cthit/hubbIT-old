class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_user
    if session[:cookie] == cookies[:chalmersItAuth] && session[:user].present?
      @current_user ||= User.find(session[:user])
    else
      reset_session
      @current_user = User.find_by_token cookies[:chalmersItAuth]
      session[:cookie] = cookies[:chalmersItAuth]
      session[:user] = @current_user.id
    end
    @current_user
  end
  helper_method :current_user

end
