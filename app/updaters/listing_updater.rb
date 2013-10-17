class ListingUpdater

  def initialize(listing, airbnb_listing)
    @listing        = listing
    @airbnb_listing = airbnb_listing
  end

  def save!
    @listing.update_attributes!({
      :name                => @airbnb_listing.name,
      :city                => @airbnb_listing.city,
      :latitude            => @airbnb_listing.lat,
      :longitude           => @airbnb_listing.lng,
      :smart_location      => @airbnb_listing.smart_location,
      :bedrooms            => @airbnb_listing.bedrooms,
      :beds                => @airbnb_listing.beds,
      :bathrooms           => @airbnb_listing.bathrooms,
      :min_nights          => @airbnb_listing.min_nights,
      :neighborhood        => @airbnb_listing.neighborhood,
      :person_capacity     => @airbnb_listing.person_capacity,
      :state               => @airbnb_listing.state,
      :zipcode             => @airbnb_listing.zipcode,
      :address             => @airbnb_listing.address,
      :country_code        => @airbnb_listing.country_code,
      :cancellation_policy => @airbnb_listing.cancellation_policy,
      :property_type       => @airbnb_listing.property_type,
      :room_type           => @airbnb_listing.room_type
    })
  end
end
