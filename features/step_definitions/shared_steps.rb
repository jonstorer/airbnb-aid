module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

When /^(.*) within (.+)$/ do |step, parent|
  with_scope(parent) { step step }
end

Given /^I am on (.+)$/ do |page_name|
  visit selector_for page_name
end

When /^I follow "([^"]+)"$/ do |text|
  click_link text
end

Then /^I should (not )?see "([^"]+)"$/ do |negator, text|
  method = negator.blank? ? :should : :should_not
  page.send method, have_content(text)
end

Then /^I fillin "([^"]+)" with "([^"]+)"$/ do |selector, value|
  fill_in(selector, :with => value)
end

Then /^I press "([^"]+)"$/ do |selector|
  click_button selector
end

When /^jobs have run$/ do
  Sidekiq::Worker.jobs.each do |job|
    puts job.flatten.join(', ')
  end
  Sidekiq::Worker.drain_all
end

Then /^show me the page$/ do
  save_and_open_page
end

When /^I wait for (\d+) seconds?$/ do |seconds|
  sleep seconds.to_i
end
