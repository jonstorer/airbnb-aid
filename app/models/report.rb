class Report
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :listing

  field :reported_at, :type => DateTime, :default => ->{ DateTime.now }
end
