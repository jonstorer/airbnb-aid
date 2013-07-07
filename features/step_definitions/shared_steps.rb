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
  email, aid, password = credentials.split('/')
  fill_in('Email', :with => email)
  fill_in('Airbnb Id', :with => aid)
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
  puts table
end
