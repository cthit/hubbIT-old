json.user_id @user.id
json.nick @user.nickname
json.total_time @total_time
json.position @ranking
json.score seconds_to_score(@total_time)

if @session.end_time <= Time.zone.now
	json.last_session_duration @last_session_duration
else
	json.last_session_duration current_session.round
end

if @longest_session.nil?
  json.longest_session "0"
  json.last_session "never"
else
  json.longest_session @longest_session
  json.last_session @session.end_time
end

