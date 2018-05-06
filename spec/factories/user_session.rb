FactoryBot.define do
  factory :user_session do
    start_time { Time.now }
    end_time { 10.minutes.from_now }
    user
  end
end
