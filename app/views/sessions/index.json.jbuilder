json.array! @sessions do |session|
    json.user_id session.user.id
    json.nick session.user.nickname
    json.(session, :start_time)
end
