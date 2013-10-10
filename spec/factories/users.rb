# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    email
    password 'sekret'
    password_confirmation 'sekret'
  end
end
