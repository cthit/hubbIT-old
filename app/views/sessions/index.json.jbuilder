json.array! @sessions.to_a do |session|
    json.user_id session.user.id
    json.nick session.user.nick
    json.(session, :start_time)
end
