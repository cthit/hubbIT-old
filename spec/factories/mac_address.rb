require 'faker'

FactoryBot.define do
  factory :mac_address, aliases: ['device'] do
    address { Faker::Internet.mac_address }
    user
  end
end
