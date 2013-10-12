require Rails.root.join 'spec/support/airbnb_api'

Before do
  $airbnb_api = AirbnbApi.new
  WebMock.stub_request(:any, /.*m.airbnb.com.*/).to_rack($airbnb_api)
end
