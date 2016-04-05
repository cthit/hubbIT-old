# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
num_users = 50
num_sessions = 10
hr_entries = 2
num_users.times do |i|
  user = User.create(cid: Faker::Internet.user_name)
  UsersTotalTime.create(user_id: user.cid, total_time: Random.rand(2000))
  adr = Faker::Internet.mac_address
  mac = MacAddress.create(user_id: user.cid, address: adr, device_name: Faker::Name.first_name)
  num_sessions.times do |i|
    start = Faker::Time.between(1.days.ago, Time.now, :all)
    end_time = Faker::Time.between(start, Time.now, :all)
    Session.create(start_time: start, end_time: end_time, mac_address: mac, user_id: user.cid)
    UserSession.create(start_time: start, end_time: end_time, user_id: user.cid)
    HourEntry.create(cid: user.cid, date: start, hour: ((end_time - start) / 1.hour).round)
  end
end
