require "securerandom"
require "bcrypt"

FactoryBot.define do
  factory :user, class: User do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { BCrypt::Password.create("password") }
    uuid { SecureRandom.hex(10) }
  end
end