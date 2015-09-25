class StatsController < ApplicationController
  include StatsHelper

  before_action :set_user

  def index
    @timeframe = params[:timeframe]
    from = if params[:from].present?
      params[:from]
    else
      case @timeframe
      when 'year'
        Date.today.beginning_of_year
      when 'month'
        Date.today.beginning_of_month
      when 'week'
        Date.today.beginning_of_week
      when 'day'
        Date.today.beginning_of_day
      else
        0
      end
    end

    to = if params[:to].present?
      params[:to]
    else
      '2099-01-01'
    end

    @active_users = UserSession.includes(:user).active.map(&:user)
    @sessions_within_timeframe = UserSession.includes(:user).time_between(from, to)
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

      @total_time = @user.users_total_time.total_time
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
