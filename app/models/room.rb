class Room
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :snapshots

  field :aid, :type => Integer
  field :name

  field :person_capacity, :type => Integer
  field :bedrooms,        :type => Integer
  field :bathrooms,       :type => Integer
  field :beds,            :type => Integer
  field :bed_type
  field :property_type
  field :room_type_category
  field :cancellation_policy
  field :user_id,       :type => Integer
  field :reviews_count, :type => Integer

  field :location, :type => Array
  field :address
  field :neighborhood
  field :city
  field :country
  field :state
  field :zipcode

  field :group, :type => Integer, :default => lambda { rand(24) }

  def snapshot
    SnapshotWorker.perform_async(id.to_s)
  end
end
