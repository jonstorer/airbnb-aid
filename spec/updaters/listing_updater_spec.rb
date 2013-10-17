require 'spec_helper'

describe ListingUpdater do
  let(:listing) { create(:listing) }

  let(:airbnb_listing) do
    Hashie::Mash.new({
      :bathrooms           => 1,
      :bedrooms            => 1,
      :beds                => 2,
      :min_nights          => 2,
      :cancellation_policy => 'strict',
      :lat                 => 72.49,
      :lng                 => 49.72,
      :name                => 'Fort Greene 1 br',
      :person_capacity     => 4,
      :property_type       => 'Apartment',
      :room_type           => 'Entire home/apt',
      :address             => 'Clermont Ave, Brooklyn, NY 11205',
      :neighborhood        => 'Fort Greene',
      :city                => 'Brooklyn',
      :state               => 'NY',
      :country_code        => 'US',
      :zipcode             => '11205',
      :smart_location      => 'Brooklyn, NY'
    })
  end

  before do
    listing.stub(:update_attributes! => true)
    ListingUpdater.new(listing, airbnb_listing).save!
  end

  it 'updates the listing with attributes from airbnb' do
    listing.should have_received(:update_attributes!).with({
      :name                => 'Fort Greene 1 br',
      :city                => 'Brooklyn',
      :latitude            => 72.49,
      :longitude           => 49.72,
      :smart_location      => 'Brooklyn, NY',
      :bedrooms            => 1,
      :beds                => 2,
      :bathrooms           => 1,
      :min_nights          => 2,
      :neighborhood        => 'Fort Greene',
      :person_capacity     => 4,
      :state               => 'NY',
      :zipcode             => '11205',
      :address             => 'Clermont Ave, Brooklyn, NY 11205',
      :country_code        => 'US',
      :cancellation_policy => 'strict',
      :property_type       => 'Apartment',
      :room_type           => 'Entire home/apt'
    })
  end
end
