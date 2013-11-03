class AirbnbApi
  FOUR_OH_FOUR = {
    :error_code    => 404,
    :error         => 'record_not_found',
    :error_message => 'Unfortunately, this is no longer available.'
  }

  attr_accessor :requests, :responses, :env
  cattr_accessor :logger

  self.logger = Logger.new(STDOUT)

  def call(env)
    self.env = env
    self.requests << request
    response = self.responses[uri] || FOUR_OH_FOUR
    log "Request:  #{uri}"
    log "Response: #{response}"
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
