class ListingWorker
  include Sidekiq::Worker

  def perform(id)
    listing = Listing.find(id)
    airbnb_listing = Airbnb::Property.find(listing.airbnb_id)
    listing.name = airbnb_listing.name
    listing.save!
  end
end
