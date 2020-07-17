json.array! @sessions do |session|
    json.user_id session.user.cid
    json.nick session.user.nick
    json.(session, :start_time)
end
