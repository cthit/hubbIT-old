json.array! @users do |user|
  json.user_id user.id
  json.(user, :nick, :total_time)
  json.score seconds_to_score(user.total_time)
  json.active user_active? user
end
