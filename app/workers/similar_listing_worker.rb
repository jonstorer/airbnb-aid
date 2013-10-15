class SimilarListingWorker
  include Sidekiq::Worker

  def perform(id)
    listing = Listing.find id
    location = "#{listing.neighborhood}, #{listing.smart_location}"
    room_type = [ listing.room_type ]

    [1,2,3,4,5].each do |page|
      FetchListingsWorker.perform_async({
        :location         => location,
        :room_type        => room_type,
        :number_of_guests => listing.person_capacity,
        :min_beds         => listing.beds,
        :min_bedrooms     => listing.bedrooms,
        :min_bathrooms    => listing.bathrooms,
        :page             => page
      })
    end
  end
end
