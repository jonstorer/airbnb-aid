Given /^I am on (.+)$/ do |page_name|
  visit selector_for page_name
end

When /^I follow "([^"]+)"$/ do |text|
  click_link text
end

Then /^I should see "([^"]+)"$/ do |text|
  page.should have_content text
end

When /^I join as "([^"]+)"$/ do |credentials|
  email, airbnb_user_id, password = credentials.split('/')
  fill_in('Email', :with => email)
  fill_in('Airbnb User Id', :with => airbnb_user_id)
  fill_in('Password', :with => password)
  fill_in('Password confirmation', :with => password)
  click_button 'Join'
end

When /^I (?:sign in|have signed in) as "([^"]+)"$/ do |email|
  user = FactoryGirl.create(:user, :email => email)
  visit '/sign_in'
  fill_in('Email',    :with => user.email)
  fill_in('Password', :with => user.password)
  click_button 'Sign in'
end

Given /^I am registered on Airbnb as:$/ do |table|
  info = table.hashes[0]
  user = { 'id' => info.delete('airbnb_user_id') }
  user.merge!(info)
  response = { :user => user }.to_json
  $airbnb_mock["/api/v1/users/#{user['id']}"] = [ 200, { "Content-length" => response.size }, [ response ] ]
end
