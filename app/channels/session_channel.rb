class SessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'sessions_index'
  end
end