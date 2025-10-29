FactoryBot.define do
  factory :fundraise do
    title { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    target_cents { rand(100_000..1_000_000) }
    status { :open }
    starts_at { Time.current }
    ends_at { 30.days.from_now }

    trait :closed do
      status { :closed }
    end

    trait :past do
      starts_at { 60.days.ago }
      ends_at { 30.days.ago }
    end
  end
end
