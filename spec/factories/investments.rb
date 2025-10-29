FactoryBot.define do
  factory :investment do
    association :user
    association :fundraise
    amount_cents { rand(10_000..100_000) }
  end
end
