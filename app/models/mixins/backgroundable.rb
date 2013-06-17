require 'active_support/concern'
module Mixins::Backgroundable
  extend ActiveSupport::Concern

  ASYNC_REGEX = Regexp.new /^async_(.+)$/

  included do
    include Sidekiq::Worker
  end

  def method_missing(method, *args)
    if method.to_s =~ ASYNC_REGEX && self.respond_to?($1, true)
      Sidekiq::Client.enqueue(self.class, self._id, $1, *args)
    else
      super
    end
  end

  def respond_to?(method, *args)
    if method.to_s =~ ASYNC_REGEX
      super($1, true)
    else
      super(method, *args)
    end
  end

  def perform(id, *args)
    self.class.find(id).send(*args)
  end
end
