class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :edit]

  def index
    @sessions = Session.all
  end

  def update
    mac = MacAddress.find_by(address: params[:mac])
    puts mac.inspect
    if mac
      @session = Session.active(mac)
      if @session.any?
        @session.first.update(end_time: DateTime.now + 5.minutes)
      else
        @session = mac.user.sessions.create(mac_address: params[:mac],
          start_time: DateTime.now, end_time: DateTime.now + 5.minutes)
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
