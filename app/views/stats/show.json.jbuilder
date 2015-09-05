json.user_id @user.id
json.nick @user.nick
json.total_time @total_time
json.position @user.ranking
json.score seconds_to_score(@total_time)
json.last_session @session.end_time
json.last_session_duration @last_session_duration
json.longest_session @longest_session
