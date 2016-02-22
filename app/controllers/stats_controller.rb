class StatsController < ApplicationController
  include StatsHelper

  before_action :set_user, except: [:get_stats]
  before_action :restrict_access, only: [:get_stats]
  def index
    @timeframe = params[:timeframe]
    @from, @to = if params[:from].present? and params[:to].present?
      [params[:from], params[:to]]
    else
      case @timeframe
      when 'year'
        [Date.today.beginning_of_year, Date.today.end_of_year]
      when 'month'
        [Date.today.beginning_of_month, Date.today.end_of_month]
      when 'week'
        [Date.today.beginning_of_week, Date.today.end_of_week]
      when 'day'
        [Date.today.beginning_of_day, Date.today.end_of_day]
      else
        [Date.new(0), Date.new(2999)]
      end
    end

    @to = @to.end_of_day

    @page = params[:page].to_i || 0
    @from, @to = change_page @page

    @active_users = UserSession.includes(:user).active.map(&:user)
    @sessions_within_timeframe = UserSession.includes(:user).time_between(@from, @to)

    if @timeframe.present?
      old_from, old_to = change_page -1
      @old_sessions_within_timeframe = UserSession.includes(:user).time_between(old_from, old_to)
    end
  end

  def get_stats
    self.index
    render 'stats/index'
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
    @longest_session = @user_sessions.longest_session.first.longest_session

    if @session.present?
      @last_session_duration = @session.end_time - @session.start_time

      @total_time = @user.users_total_time.total_time
      @ranking = @user.ranking
    else
      @last_session_duration = 0
      @total_time = 0
      @ranking = 0
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
    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
end
