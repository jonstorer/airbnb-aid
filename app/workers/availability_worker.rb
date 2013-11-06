class AvailabilityWorker
  include Sidekiq::Worker
  sidekiq_options({ :throttle => { :threshold => 1, :period => 8.seconds } })

  def perform(params)
    listing = Listing.find params[:id]
    airbnb_listing = Airbnb::Listing.find(listing.airbnb_id)
    airbnb_listing.available?(Date.parse(params[:checkin]), Date.parse(params[:checkout]), listing.person_capacity)
  end
end
