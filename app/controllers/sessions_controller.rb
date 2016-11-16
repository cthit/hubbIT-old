class SessionsController < ApplicationController
  include SessionsHelper
  before_action :restrict_access, only: [:index, :update]

  @@semaphore = Mutex.new

  def index
    @sessions = UserSession.active.includes(:user)
    @groups = map_users_to_groups(@sessions.map { |s| {user: s.user, groups: s.user.groups} })

    respond_to do |format|
      format.json
      format.html
    end
  end

  def update
    macs = params[:macs]
    unless macs.present?
      render json: {error: 'macs cannot be nil'}, status: :unprocessable_entity
      return
    end

    @@semaphore.synchronize do
        macs.each do |address|
          address, count = address
          mac = MacAddress.find_by(address: address.upcase)
          next unless mac.present?

          @user = mac.user
          @session = Session.active.with_mac(mac)
          new_time = DateTime.now + 10.minutes
          if @session.any?
            @session.first.update(end_time: new_time)
          else
            logger.info("Creating session for #{@user.id} (#{address})")
            @session = @user.sessions.create(mac_address: mac,
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
    end
    head :no_content
  end

  private
    def session_params
      params.require(:session).permit(:mac_address, :user_id, :start_time, :end_time)
    end

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
end
