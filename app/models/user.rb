class User < ActiveResource::Base
  extend ActiveModel::Naming
  self.site = Rails.configuration.account_ip
  ALLOWED_GROUPS = [:styrit, :snit, :sexit, :prit, :nollkit, :armit, :digit, :fanbarerit, :fritid, :'8bit', :drawit, :flashit, :hookit, :revisorer, :valberedningen, :laggit, :fikit]

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

  def destroy
    devices.delete_all
    sessions.delete_all
    user_sessions.delete_all
    hour_entries.delete_all
  end
end

class Symbol
  def itize
    case self
      when :digit, :styrit, :sexit, :fritid, :snit
        self.to_s.gsub /it/, 'IT'
      when :drawit, :armit, :hookit, :flashit, :laggit, :fikit
        self.to_s.titleize.gsub /it/, 'IT'
      when :'8bit'
        '8-bIT'
      when :nollkit
        'NollKIT'
      when :prit
        'P.R.I.T.'
      when :fanbarerit
        'FanbärerIT'
      when :valberedningen
        'Valberedningen'
      when :revisorer
        'Revisorerna'
      when :dpo
        'DPO'
      else
        self.to_s
    end
  end
end
