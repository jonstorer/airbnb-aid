require "cgi"
module Helpers

  def airbnb_listing(attrs={})
    attrs.reverse_merge!({
      :id           => FactoryGirl.generate(:airbnb_id),
      :room_type    => 'Entire home/apt',
      :bathrooms    => 1,
      :beds         => 1,
      :address      => '150 Clermont Ave',
      :city         => 'Brooklyn',
      :state        => 'NY',
      :zipcode      => 11205,
      :country_code => 'US',
      :neighborhood => 'Fort Greene',
      :lat          => 72.34,
      :lng          => 72.30
    })
    attrs['smart_location'] = "#{attrs['city']}, #{attrs['state']}"
    $airbnb_api["/api/-/v1/listings/#{attrs[:id]}"] ||= { :listing => attrs }
    attrs
  end

  def current_user
    User.where(:remember_me_token => cookies['remember_me_token']).first
  end

  def cookies
    Capybara.current_session.driver.browser.current_session.instance_variable_get("@rack_mock_session").cookie_jar
  end
end

World(Helpers)
