class ListingWorker
  include Sidekiq::Worker
  sidekiq_options({ })

  def perform(id)
    listing  = Listing.find(id)

    criteria = Listing.where({ })

    min_beds = [listing.beds - 1, 1].min
    max_beds = listing.beds + 1
    criteria = criteria.between({:beds => min_beds..max_beds})

    min_bedrooms = [listing.bedrooms - 1, 1].min
    max_bedrooms = listing.bedrooms + 1
    criteria     = criteria.between({:bedrooms => min_bedrooms..max_bedrooms})

    listings = criteria.to_a

    avg_beds     = listings.sum(&:beds)     / listings.count
    avg_bedrooms = listings.sum(&:bedrooms) / listings.count

    listing.reports.create({
      :average_number_of_beds      => avg_beds,
      :average_number_of_bedrooms => avg_bedrooms
    })
  end
end

