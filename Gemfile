source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 4.0.0'
gem 'mongoid', :github => 'mongoid'

gem 'coffee-rails', '>= 4.0.0'
gem 'jquery-rails'
gem 'sass-rails', '>= 4.0.0'
gem 'simple_form', '>= 3'

gem 'sinatra', :require => nil

gem 'sidekiq'
gem 'sidekiq-throttler'
gem 'sidekiq-unique-jobs'

gem 'redis'

# use this when running on servers
# https://github.com/ondrejbartas/sidekiq-cron

gem 'airbnb', :git => 'git@github.com:jonstorer/airbnb.git'

gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'

gem 'uglifier', '>= 1.3.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '>= 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

group :test, :development do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'factory_girl_rails', '>= 4.2'
  gem 'foreman', '0.63.0'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-mocks'
  gem 'mongoid-rspec'
  gem 'rspec-rails', '>= 2.0'
  gem 'timecop', '>= 0.6'
  gem 'webmock', '>= 1.13.0'
end
