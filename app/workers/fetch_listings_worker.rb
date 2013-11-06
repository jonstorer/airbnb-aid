class FetchListingsWorker
  include Sidekiq::Worker
  sidekiq_options({
    :throttle => { :threshold => 1, :period => 8.seconds },
    :unique => true,
    :unique_unlock_order => :before_yield
  })

  def perform(params)
    Airbnb::Listing.fetch(params).each do |airbnb_listing|
      listing = Listing.find_or_create_by({ :airbnb_id => airbnb_listing.id })
      ListingUpdater.new(listing, airbnb_listing).save!
    end
  end
end
