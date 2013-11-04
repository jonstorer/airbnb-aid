class AirbnbApi
  class MissingStubbedResponse < Exception; end

  attr_accessor :requests, :responses, :env

  def call(env)
    self.env = env
    self.requests << request
    response = self.responses[uri]
    log "Request:  #{uri}"
    log "Response: #{response || 'Missing stubbed response'}"
    raise(MissingStubbedResponse) unless response
    response
  end

  def initialize
    self.responses = {}
    self.requests  = []
  end

  def []=(uri, body, status=200)
    body = body.to_json
    self.responses[uri] = [ status, { "Content-length" => body.size }, [ body ] ]
  end

  def [](uri)
    self.responses[uri]
  end

  private

  def request
    Rack::Request.new(self.env)
  end

  def uri
    request.path_info
  end

  def log(message)
    Rails.logger.info "API: Airbnb: #{message}"
  end
end
