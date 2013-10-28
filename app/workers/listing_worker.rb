class ListingWorker
  include Sidekiq::Worker
  sidekiq_options({
    :throttle => { :threshold => 1, :period => 8.seconds },
    :queue => 'high'
  })

  def perform(id)
    listing = Listing.find(id)
    begin
      ListingUpdater.new(listing, Airbnb::Listing.find(listing.airbnb_id)).save!
    rescue Airbnb::RecordNotFound => e
      listing.update_attributes!(:active => false)
    end
  end
end
