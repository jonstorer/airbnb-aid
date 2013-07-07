require 'uri'
require 'cgi'

require Rails.root.join 'spec/support/api_mock'
require Rails.root.join 'spec/support/airbnb_mock'

$airbnb_mock = AirbnbMock.new
WebMock.stub_request(:any, /.*airbnb.com.*/).to_rack($airbnb_mock)
