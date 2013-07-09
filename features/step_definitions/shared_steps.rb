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

Then /^I should see "([^"]+)"$/ do |text|
  page.should have_content text
end
