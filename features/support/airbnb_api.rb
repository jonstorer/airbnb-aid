class AirbnbApi
  attr_accessor :requests, :responses, :env

  def call(env)
    self.env = env
    self.requests << request
    self.responses[uri]
  end

  def initialize
    self.responses = {}
    self.requests  = []
  end

  def []=(uri, body, status=200)
    body = body.to_json
    self.responses[uri] = [ status, { "Content-length" => body.size }, [ body ] ]
  end

  private

  def request
    Rack::Request.new(self.env)
  end

  def uri
    request.path_info
  end
end

Before do
  $airbnb_api = AirbnbApi.new
  WebMock.stub_request(:any, /.*m.airbnb.com.*/).to_rack($airbnb_api)
end
