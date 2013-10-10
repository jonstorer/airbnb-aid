Given /^airbnb returns the following for listing (\d+)$/ do |airbnb_id, table|
  $airbnb_api["/api/-/v1/listings/#{airbnb_id}"] = { :listing => table.hashes[0].merge(:id => airbnb_id) }
end
