Given /^airbnb returns the following for listing (\d+)$/ do |airbnb_id, table|
  listing = airbnb_listing(table.hashes[0].merge(:id => airbnb_id))
  $airbnb_api["/api/-/v1/listings/#{airbnb_id}"] = { :listing => listing }
end

Given /^airbnb returns the following similar listings for page (\d+) for listing (\d+)$/ do |page, airbnb_id, table|
  #https://m.airbnb.com?items_per_page=10&location=Fort+Greene%2C+Brooklyn%2C+NY&min_bathrooms=1&min_bedrooms=2&min_beds=1&number_of_guests=4&offset=0
  listings = table.hashes.map {|hash| { :listing => airbnb_listing(hash) } }
  $airbnb_api["/api/-/v1/listings/search"] = { :listings => listings }
end
