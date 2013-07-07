class ApiMock
  attr_accessor :requests, :responses, :service_status, :env

  def initialize
    self.responses = {}
    self.requests  = []
  end

  def call(env)
    self.env = env
    #raise Net::HTTPBadResponse if service_status == "down"
  end

  def request
    Rack::Request.new(self.env)
  end

  def uri
    request.path_info
  end

  def []=(uri, response)
    self.responses[uri] = response
  end

  def [](uri)
    self.responses[uri]
  end
end
