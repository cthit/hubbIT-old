class LoginController < ApplicationController
  def create
    s = request.env['omniauth.auth']
    session[:user_id] = s.uid
    redirect_to root_url
  end
end
