class SimilarListingWorker
  include Sidekiq::Worker

  def perform(id)
    listing = Listing.find id
    location = "#{listing.neighborhood}, #{listing.smart_location}"
    room_type = [ listing.room_type ]

    min_number_of_guests = [listing.person_capacity - 2, 1].max
    max_number_of_guests = listing.person_capacity + 2

    min_number_of_beds = [listing.beds - 1, 1].max
    max_number_of_beds = listing.beds + 1

    min_number_of_bedrooms = [listing.bedrooms - 1, 0].max
    max_number_of_bedrooms = listing.bedrooms + 1

    min_number_of_bathrooms = [listing.bathrooms - 1, 1].max
    max_number_of_bathrooms = listing.bathrooms + 1

    (min_number_of_beds..max_number_of_beds).to_a.each do |beds|
      (min_number_of_bedrooms..max_number_of_bedrooms).to_a.each do |bedrooms|
        (min_number_of_guests..max_number_of_guests).to_a.each do |number_of_guests|
          [1,2,3,4,5].each do |page|
            Airbnb::Listing.fetch({
              :number_of_guests => number_of_guests,
              :min_beds         => beds,
              :min_bedrooms     => bedrooms,
              :page             => page
            })
          end
        end
      end
    end
  end
end
