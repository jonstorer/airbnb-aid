class FetchListingsWorker
  include Sidekiq::Worker

  def perform(params)
    Airbnb::Listing.fetch(params).each do |airbnb_listing|
      listing = Listing.find_or_create_by({
        :airbnb_id => airbnb_listing['id']
      })
      listing.update_attributes!({
        :name                => airbnb_listing['name'],
        :city                => airbnb_listing['city'],
        :latitude            => airbnb_listing['lat'],
        :longitude           => airbnb_listing['lng'],
        :country             => airbnb_listing['country'],
        :smart_location      => airbnb_listing['smart_location'],
        :bedrooms            => airbnb_listing['bedrooms'],
        :beds                => airbnb_listing['beds'],
        :neighborhood        => airbnb_listing['neighborhood'],
        :person_capacity     => airbnb_listing['person_capacity'],
        :state               => airbnb_listing['state'],
        :zipcode             => airbnb_listing['zipcode'],
        :address             => airbnb_listing['address'],
        :country_code        => airbnb_listing['country_code'],
        :cancellation_policy => airbnb_listing['cancellation_policy'],
        :property_type       => airbnb_listing['property_type'],
        :room_type           => airbnb_listing['room_type']
      })
    end
  end
end
