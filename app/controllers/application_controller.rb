class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from SecurityError do |error|
    respond_to do |format|
      format.json { render json: {error: error}, status: :forbidden }
      format.html { not_signed_in }
    end
  end

  def current_user?
    begin
      @current_user || current_user
    rescue SecurityError
      false
    end
  end

  def current_user
    if session[:user_id]
      @current_user = User.find session[:user_id]
    else
      raise SecurityError, "Not signed in"
    end
  end
  helper_method :current_user

  private
    def not_signed_in
      redirect_to '/auth/account'
    end
end
