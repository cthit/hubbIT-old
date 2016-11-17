class SessionsController < ApplicationController
  include SessionsHelper
  before_action :restrict_access

  @@semaphore ||= Mutex.new

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
    @addresses = macs.map do |m|
      address, count = m
      address.upcase
    end

    @@semaphore.synchronize do
        @addresses = MacAddress.where('address IN (?)', @addresses)
        now = DateTime.now
        new_time = now + 10.minutes

        @addresses.each do |mac|
          @user = mac.user
          sessions = mac.sessions.active

          if sessions.any?
            @session = sessions.first.update(end_time: new_time)
          else
            logger.info("Creating session for #{@user.id} (#{mac.address})")
            @session = sessions.create(start_time: now, end_time: new_time)
          end

          @u_session = @user.user_sessions.active
          if @u_session.any?
            new_session = @u_session.last
            if new_session.update(end_time: new_time)
              ActionCable.server.broadcast('sessions_index', new_session)
            end
          else
            new_session = @user.user_sessions.create(start_time: now, end_time: new_time)
            ActionCable.server.broadcast('sessions_index', new_session)
          end

          @user.hour_entries.find_or_create_by(date: Date.today, hour: now.hour)
        end
    end
    head :no_content
  end

  private
    def session_params
      params.require(:session).permit(:mac_address, :user_id, :start_time, :end_time)
    end

    def restrict_access
      current_user? || authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
end
