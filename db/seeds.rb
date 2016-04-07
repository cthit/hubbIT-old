# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
NUM_USERS = 25
NUM_SESSIONS = 20

puts "Creating users with sessions and mac addresses"
NUM_USERS.times do |i|
  #Create user with fake cid
  user = User.create(cid: Faker::Internet.user_name)

  #Create fake total_time
  UsersTotalTime.create(user_id: user.cid, total_time: Random.rand(2000))

  #Create fake mac_address
  adr = Faker::Internet.mac_address
  mac = MacAddress.create(user_id: user.cid, address: adr, device_name: Faker::Name.first_name)

  #Create fake sessions
  NUM_SESSIONS.times do |i|
    #Creates starting time somewhere between the last 40 days
    start = Faker::Time.between(40.days.ago, Time.now, :all)
    #Creates an end time that lies within the start times next 24hrs
    end_time = Faker::Time.between(start, start + 1.day, :all)

    Session.create(start_time: start, end_time: end_time, mac_address: mac, user_id: user.cid)
    UserSession.create(start_time: start, end_time: end_time, user_id: user.cid)
    HourEntry.create(cid: user.cid, date: start, hour: ((end_time - start) / 1.hour).round)
  end
end
