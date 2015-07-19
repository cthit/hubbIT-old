class StatsController < ApplicationController

  before_action :set_user
  def index
    @sessions = UserSession.group(:user_id)
    @total_time = @sessions.select('id','user_id','sum(TIME_TO_SEC(end_time) - TIME_TO_SEC(start_time)) as total_time').order("total_time DESC")
  end


  def hours
    query = HourEntry.group(:hour)
    query = query.with_user(@user.cid) if params[:user_id]
    render json: query.count
  end

  def show
    user_sessions = UserSession.with_user(@user).order("-created_at")
    @session = user_sessions.first

    if @session.present?
      @last_session_duration = @session.end_time - @session.start_time

      @total_time = user_sessions.sum('TIME_TO_SEC(end_time) - TIME_TO_SEC(start_time)')
    end
  end

  private
    def set_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = current_user
      end
    end
end
