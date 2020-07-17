class SessionsController < ApplicationController
  include SessionsHelper
  before_action :authenticate

  @@semaphore ||= Mutex.new

  def index
    @sessions = UserSession.active
    @groups = map_users_to_groups(@sessions.map { |s| s.user_id }.uniq )

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

    @addresses = MacAddress.where('address IN (?)', @addresses)
    @users = @addresses.map(&:user).uniq

    @@semaphore.synchronize do
      now = DateTime.now
      new_time = now + 10.minutes
      sessions_to_save = []
      user_sessions_to_save = []
      hour_entries_to_save = []

      @addresses.each do |mac|
        sessions = mac.sessions.active

        session = sessions.first_or_initialize do |s|
          s.user = mac.user
          s.start_time = now

          logger.info("Creating session for #{mac.user.cid} (#{mac.address})")
        end
        session.end_time = new_time

        sessions_to_save << session
      end

      @users.each do |user|
        user_sessions = user.user_sessions.active

        new_record = false
        user_session = user_sessions.first_or_initialize do |us|
          us.start_time = now
          new_record = true
        end
        user_session.end_time = new_time
        user_sessions_to_save << user_session
        ActionCable.server.broadcast('sessions_index', user_session) if new_record

        hour_entry = user.hour_entries.where(date: Date.today, hour: now.hour).first_or_initialize
        hour_entries_to_save << hour_entry
      end

      Session.transaction do
        UserSession.transaction do
          HourEntry.transaction do
            sessions_to_save.each(&:save!)
            user_sessions_to_save.each(&:save!)
            hour_entries_to_save.each(&:save!)
          end
        end
      end
    end

    head :no_content
  end

  private
    def session_params
      params.require(:session).permit(:mac_address, :user_id, :start_time, :end_time)
    end

    def authenticate
      authenticated, token_present = authenticate_token
      return if authenticated

      raise SecurityError.new "HTTP Token: Access denied" if token_present

      current_user
    end

    def authenticate_token
      token_is_set = false
      res = authenticate_with_http_token do |token, options|
        token_is_set = token.present?
        ApiKey.exists?(access_token: token)
      end

      [res, token_is_set]
    end
end
