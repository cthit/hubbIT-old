json.user_id @user.id
json.nick @user.nick
json.total_time @total_time
json.position @ranking
json.score seconds_to_score(@total_time)
json.last_session_duration @last_session_duration

if @longest_session.nil?
  json.longest_session "0"
  json.last_session "never"
else
  json.longest_session @longest_session
  json.last_session @session.end_time
end

