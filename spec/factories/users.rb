# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do
  sequence(:email) {|n| "user#{n}@example.com" }
  sequence(:aid)   {|n| n }

  factory :user do
    aid
    email
    password 'sekret'
    password_confirmation 'sekret'
    after(:build) do |user|
      response = { :user => { :id => user.aid } }.to_json
      $airbnb_mock["/api/v1/users/#{user.aid}"] = [ 200, { "Content-length" => response.size }, [ response ] ]
    end
  end
end
