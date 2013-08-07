When /^I join as "([^"]+)"$/ do |credentials|
  email, password = credentials.split('/')
  click_link 'Join'
  fill_in('Email',                      :with => email)    unless email.blank?
  fill_in('user_password',              :with => password) unless password.blank?
  fill_in('user_password_confirmation', :with => password) unless password.blank?
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
