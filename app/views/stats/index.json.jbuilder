json.array! @total_time do |user_session|
  json.(user_session, :user_id, :total_time)
  json.nick User.nick(user_session.user_id)
  json.score seconds_to_score(user_session.total_time)
  json.active user_active? user_session
end
