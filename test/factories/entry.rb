require "securerandom"

FactoryBot.define do
  factory :entry, class: Entry do
    token { SecureRandom.base58(24) }
    status { (0..1).to_a.sample }
    sequence(:title) { |n| "entry#{n}" }
    sequence(:tags) { |n| "entry#{n},test" }
    sequence(:content) { |n| "This is entry#{n}" }
    user_token { nil }
  end
end