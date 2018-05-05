FactoryBot.define do
  factory :user do
    cid { Faker::Internet.domain_word }

    factory :user_with_devices do
      transient do
        device_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:device, evaluator.device_count, user: user)
      end
    end
  end
end
