FactoryGirl.define do
  sequence(:airbnb_id)

  factory :listing do
    airbnb_id { generate(:airbnb_id) }
    name '1 Br in Fort Greene'
    city 'Brooklyn'
    state 'NY'
    zipcode 11205
    country_code 'US'
    smart_location 'Brooklyn, NY'
    neighborhood 'Fort Greene'
    address 'Clermont Ave, Brooklyn, NY 11205, United States'
    latitude 40.693278
    longitude -73.971029
    bedrooms 1
    beds 2
    person_capacity 4
    room_type 'Entire home/apt'
    cancellation_policy 'strict'
  end
end
