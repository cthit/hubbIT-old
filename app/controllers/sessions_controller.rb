class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :edit]

  def index
    @sessions = UserSession.active
  end

  def update
    mac = MacAddress.find_by(address: params[:Mac])
    puts params
    puts mac.inspect
    if mac
      @user = mac.user
      @session = Session.active.with_mac(mac)
      new_time = DateTime.now + 5.minutes
      if @session.any?
        @session.first.update(end_time: new_time)
      else
        @session = @user.sessions.create(mac_address: params[:Mac],
          start_time: DateTime.now, end_time: new_time)
      end

      @u_session = UserSession.active.with_user(@user)
      if @u_session.any?
        @u_session.last.update(end_time: new_time)
      else
        @user.user_sessions.create(start_time: DateTime.now, end_time: new_time)
      end

      @hentry = HourEntry.with_user(@user).last
      if @hentry.nil? || (@hentry.date < Date.today || @hentry.hour < DateTime.now.hour)
        @user.hour_entries.create(date: Date.today, hour: DateTime.now.hour)
      end

    end
    head :no_content
  end

  def show
  end

  private
    def session_params
      params.require(:session).permit(:mac_address, :user_id, :start_time, :end_time)
    end

    def set_session
      @session = Session.find(params[:id])
    end
end
