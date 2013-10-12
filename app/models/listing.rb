class Listing
  include Mongoid::Document
  include Mongoid::Timestamps

  field :airbnb_id
  validates :airbnb_id, :presence => { :message => 'is required' }

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
  field :person_capacity, :type => Integer

  field :property_type
  field :room_type
  field :cancellation_policy

  after_create :queue_update

  def name
    attributes['name'] || "Listing #{airbnb_id}"
  end

  private

  def queue_update
    ListingWorker.perform_async(self.to_param)
  end
end
