class AvailabilityWorker
  include Sidekiq::Worker
  sidekiq_options({ :throttle => { :threshold => 1, :period => 8.seconds } })

  def perform(params)
    listing = Listing.find params[:id]
    airbnb_listing = Airbnb::Listing.new({
      :id         => listing.airbnb_id,
      :min_nights => listing.min_nights
    })
    airbnb_listing.available?(:checkin => params[:checkin], :checkout => params[:checkout])
  end
end
