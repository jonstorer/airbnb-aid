class ListingWorker
  include Sidekiq::Worker
  sidekiq_options({ :queue => 'high', :throttle => { :threshold => 1, :period => 10.seconds } })

  def perform(id)
    listing = Listing.find(id)

    begin
      airbnb_listing = Airbnb::Listing.find(listing.airbnb_id)

      listing.name                = airbnb_listing.name
      listing.city                = airbnb_listing.city
      listing.zipcode             = airbnb_listing.zipcode
      listing.country_code        = airbnb_listing.country_code
      listing.smart_location      = airbnb_listing.smart_location
      listing.neighborhood        = airbnb_listing.neighborhood
      listing.address             = airbnb_listing.address
      listing.latitude            = airbnb_listing.lat
      listing.longitude           = airbnb_listing.lng
      listing.bedrooms            = airbnb_listing.bedrooms
      listing.beds                = airbnb_listing.beds
      listing.bathrooms           = airbnb_listing.bathrooms
      listing.person_capacity     = airbnb_listing.person_capacity
      listing.property_type       = airbnb_listing.property_type
      listing.room_type           = airbnb_listing.room_type
      listing.cancellation_policy = airbnb_listing.cancellation_policy

    rescue Airbnb::RecordNotFound => e
      listing.active = false
    end
    listing.save!
  end
end
