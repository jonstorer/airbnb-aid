class Listing
  include Mongoid::Document
  include Mongoid::Timestamps

  WATCHED_FIELDS = [ :city, :state, :zipcode, :country_code,
                     :neighborhood, :address, :latitude, :longitude,
                     :bedrooms, :beds, :person_capacity ]

  scope :active, where(:active => true)

  field :airbnb_id, :type => Integer
  validates :airbnb_id, :presence => { :message => 'is required' }, :uniqueness => true

  field :active, :type => Boolean, :default => true
  field :name
  field :city
  field :state
  field :zipcode
  field :country_code
  field :smart_location
  field :neighborhood
  field :address
  field :latitude,  :type => Float
  field :longitude, :type => Float

  field :bedrooms,        :type => Integer
  field :beds,            :type => Integer
  field :bathrooms,       :type => Integer
  field :person_capacity, :type => Integer
  field :min_nights,      :type => Integer

  field :property_type
  field :room_type
  field :cancellation_policy

  after_create :queue_update
  after_update :queue_find_similar_listings, :if => :active_and_required_fields_present_and_watched_field_changed?

  def name
    attributes['name'] || "Listing #{airbnb_id}"
  end

  private

  def queue_update
    ListingWorker.perform_async(self.to_param)
  end

  def queue_find_similar_listings
    SimilarListingWorker.perform_async(self.to_param)
  end

  def active_and_required_fields_present_and_watched_field_changed?
    active? && required_fields_present? && watched_field_changed?
  end

  def required_fields_present?
    WATCHED_FIELDS.all?{|field| __send__(field).present? }
  end

  def watched_field_changed?
    WATCHED_FIELDS.any?{|field| __send__ "#{field}_changed?" }
  end
end
