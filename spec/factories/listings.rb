FactoryGirl.define do

  sequence(:airbnb_id)

  factory :listing do
    airbnb_id
  end

end
