require "cgi"
module Helpers
  def current_user
    User.where(:remember_me_token => cookies['remember_me_token']).first
  end

  def cookies
    Capybara.
      current_session.
      driver.
      browser.
      current_session.
      instance_variable_get("@rack_mock_session").
      cookie_jar
  end
end

World(Helpers)
