class StatsController < ApplicationController

  before_action :set_user

  def index
    @active_users = UserSession.includes(:user).active.map(&:user)
    @total_time = UserSession.total_time
  end


  def hours
    cache_key = 'hours'
    query = HourEntry.group(:hour)
    if params[:user_id]
      user_id = params[:user_id]
      cache_key = "hours/#{user_id}"
      query = query.with_user(user_id)
    end

    @count = Rails.cache.fetch cache_key, expires_in: 5.minutes do
      query.count
    end

    render json: @count
  end

  def show
    @user_sessions = UserSession.with_user(@user).order("-created_at")
    @session = @user_sessions.first
    @longest_session = @user_sessions.maximum('TIME_TO_SEC(end_time) - TIME_TO_SEC(start_time)')

    if @session.present?
      @last_session_duration = @session.end_time - @session.start_time

      @total_time = @user_sessions.select('sum(TIMESTAMPDIFF(SECOND, `start_time`, `end_time`)) as total_time')
      .order("total_time DESC")
      .first().total_time
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
