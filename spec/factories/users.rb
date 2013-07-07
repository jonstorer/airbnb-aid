# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do
  sequence(:email)          { |n| "user#{n}@example.com" }
  sequence(:airbnb_user_id) { |n| n }

  factory :user do
    airbnb_user_id
    email
    password 'sekret'
    password_confirmation 'sekret'
    after(:build) do |user|
      response = { :user => { :id => user.airbnb_user_id } }.to_json
      $airbnb_mock["/api/v1/users/#{user.airbnb_user_id}"] = [ 200, { "Content-length" => response.size }, [ response ] ]
    end
  end
end
