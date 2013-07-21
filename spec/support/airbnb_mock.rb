class AirbnbMock < ApiMock
  def call(env)
    super
    self.requests << request
    self[uri]
  end
end
