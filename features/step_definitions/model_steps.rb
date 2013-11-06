Given(/^I have the following listing:$/) do |table|
  table.hashes.each do |listing|
    listing = FactoryGirl.create(:listing, listing)
    user = current_user
    user.listings << listing
    user.save!
  end
end
