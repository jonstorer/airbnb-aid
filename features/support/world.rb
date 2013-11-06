require 'uri'
require 'cgi'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

Before do
  $redis.flushall
end
