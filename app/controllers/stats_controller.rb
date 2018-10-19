class StatsController < ApplicationController
  include StatsHelper

  before_action :set_user, except: [:get_stats]
  before_action :restrict_access, only: [:get_stats]
  def index
    @study_year_index = get_current_study_year_index
    @study_period_index = get_current_study_period_index
    @timeframe = params[:timeframe] || 'study_year'
    @from, @to = if params[:from].present? and params[:to].present?
      [params[:from], params[:to]]
    else
      case @timeframe
      when 'all_time'
        [Date.new(0), Date.new(2999)]
      when 'year'
        [Date.today.beginning_of_year, Date.today.end_of_year]
      when 'study_year'
        get_study_year @study_year_index
      when 'study_period'
        get_study_period @study_period_index
      when 'month'
        [Date.today.beginning_of_month, Date.today.end_of_month]
      when 'week'
        [Date.today.beginning_of_week, Date.today.end_of_week]
      when 'day'
        [Date.today.beginning_of_day, Date.today.end_of_day]
      end
    end

    @to = @to.end_of_day

    @page = params[:page].to_i || 0
    @from, @to = change_page @page

    @active_users = UserSession.active.map(&:user)
    @sessions_within_timeframe = UserSession.time_between(@from, @to)

    if @timeframe.present?
      old_from, old_to = change_page -1
      @old_sessions_within_timeframe = UserSession.time_between(old_from, old_to)
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



  #here be stupidity. 
  def show
    @from, @to = [Date.new(0), Date.new(2999)]
    @sessions_within_timeframe = UserSession.time_between(@from, @to)

    @user_sessions = UserSession.with_user(@user).order("-created_at")
    @session = @user_sessions.first
    @longest_session = @user_sessions.with_longest_session.first.longest_session

    if @session.present?
      @last_session_duration = @session.end_time - @session.start_time
      @total_time = 0
      @ranking = 0
      @average_time = 0
      @year_ranking = 0
      @from1, @to1 = get_study_year get_current_study_year_index
      @sessions_within_timeframe_year = UserSession.includes(:user).time_between(@from1, @to1)
      if @sessions_within_timeframe_year.each_with_index do |session, index|
         @year_ranking = index + 1
      end 
      @sessions_within_timeframe.each_with_index do |session, index|
          if @user == session.user
              @total_time = session.total_time
              @ranking = index + 1
              @percent_total =  (@total_time.to_f/ ( Time.now.to_f -  @user_sessions.last.start_time.to_f ))
              @average_time = @percent_total * 3600 * 24
              break
          end
        
      
        end
    else
      @last_session_duration = 0
      @total_time = 0
      @ranking = 0
    end
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
