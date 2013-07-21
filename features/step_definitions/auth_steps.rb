When /^I join as "([^"]+)"$/ do |credentials|
  email, airbnb_user_id, password = credentials.split('/')
  click_link 'Join'
  fill_in('Email',                      :with => email)          unless email.blank?
  fill_in('Airbnb User Id',             :with => airbnb_user_id) unless airbnb_user_id.blank?
  fill_in('user_password',              :with => password)       unless password.blank?
  fill_in('user_password_confirmation', :with => password)       unless password.blank?
  click_button 'Join'
end

When /^I (?:sign in|have signed in) as "([^"]+)"$/ do |credentials|
  email, password = credentials.split('/')
  user = FactoryGirl.create(:user, :email => email)
  password ||= user.password
  click_link 'Sign In'
  fill_in('Email',    :with => user.email)
  fill_in('Password', :with => password)
  click_button 'Sign in'
end

Given /^I am registered on Airbnb as:$/ do |table|
  info = table.hashes[0]
  user = { 'id' => info.delete('airbnb_user_id') }
  user.merge!(info)
  response = { :user => user }.to_json
  $airbnb_mock["/api/v1/users/#{user['id']}"] = [ 200, { "Content-length" => response.size }, [ response ] ]
end
