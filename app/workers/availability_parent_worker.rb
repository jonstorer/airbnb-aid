class AvailabilityParentWorker
  include Sidekiq::Worker
  sidekiq_options({ :throttle => { :threshold => 1, :period => 8.seconds } })

  def perform(id)
    listing = Listing.find id
    (0..30).each do |n|
      AvailabilityParentWorker.perform_async({
        :id       => listing.to_param,
        :checkin  => n.days.from_now.to_date,
        :checkout => (n + listing.min_nights).days.from_now.to_date
      })
    end
  end
end
