Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Kiqstand::Middleware
    chain.add Sidekiq::Throttler, :storage => :redis
  end
end
