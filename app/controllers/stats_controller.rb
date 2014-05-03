class StatsController < ApplicationController

  before_action :set_user

  def hours
    render json: HourEntry.with_user(@user).group(:hour).count
  end

  def show
    user_sessions = UserSession.with_user(@user)
    session = user_sessions.first

    if session.present?
      @last_session = session.end_time - session.start_time

      @total_time = user_sessions.sum('end_time - start_time')
    end
  end

  private
    def set_user
      return @user = nil if params[:user_id] == 0
      @user = params[:user_id] || current_user
    end
end
