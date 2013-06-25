class Snapshot
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :room

  field :guests_included
  field :price
  field :max_nights
  field :min_nights
  field :person_capacity
  field :price
  field :price_for_extra_person_native
  field :reviews_count
  field :security_deposit
  field :weekly_price_native
end
