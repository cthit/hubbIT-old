FactoryBot.define do
  factory :session do
    start_time { Time.now }
    end_time { 10.minutes.from_now }
    device
    user
  end
end
