# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def random_mac
  (0..15).to_a.sample(12).map{ |n| n.to_s(16) }.each_slice(2).to_a.map { |arr| arr.join }.join(":").upcase
end

ALPHABET = ('a'..'z').to_a

def random_cid(len = 7)
  ALPHABET.sample(len).join
end


30.times do
  u = User.create(cid: random_cid)
  [1, 2, 3].sample.times do
    u.devices.create(address: random_mac)
  end
end
