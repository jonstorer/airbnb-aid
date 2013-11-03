Given /^airbnb returns the following for listing (\d+)$/ do |airbnb_id, table|
  $airbnb_api["/api/-/v1/listings/#{airbnb_id}"] = { :listing => table.hashes[0].merge(:id => airbnb_id) }
end

Given /^airbnb returns the following similar listings for page (\d+) for listing (\d+)$/ do |page, airbnb_id, table|
  listing = Listing.where(:airbnb_id => airbnb_id).first

  $airbnb_api["/api/-/v1/listings/#{airbnb_id}"] = {
    :listings => table.hashes.map {|listing| { :listing => airbnb_listing(listing) } }
  }
end
