class User < ActiveResource::Base
  extend ActiveModel::Naming
  self.site = Rails.configuration.account_ip

  def devices
    @devices ||= MacAddress.where user_id: self.id
  end

  def sessions
    @sessions ||= Session.where user_id: self.id
  end

  def user_sessions
    @usessions ||= UserSession.where user_id: self.id
  end

  def hour_entries
    @hentries ||= HourEntry.where cid: self.id
  end

  def self.headers
    { 'authorization' => "Bearer #{Rails.application.secrets.client_credentials}" }
  end
end
