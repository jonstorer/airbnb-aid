require 'spec_helper'

describe FetchListingsWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    FetchListingsWorker.get_sidekiq_options['queue'].should == 'default'
  end
end

describe FetchListingsWorker, '#perform, it fetches similar listings' do
  subject { FetchListingsWorker }

  let(:attributes) do
    { 'location' => 'Crown Heights, Brooklyn, NY', 'room_type' => ['Private room'], 'number_of_guests' => 6, 'min_beds' => 2, 'min_bedrooms' => 7, 'min_bathrooms' => 2, 'page' => 1 }
  end

  let(:result_one) do
    { 'id' => 900691, 'city' => 'New York', 'lat' => 40.75747813141989, 'lng' => -73.99101412904595, 'country' => 'United States', 'name' => 'Times Square, Queen Bed, Big Futon!', 'smart_location' => 'New York, NY', 'bedrooms' => 1, 'beds' => 1, 'neighborhood' => "Hell's Kitchen", 'person_capacity' => 4, 'state' => 'NY', 'zipcode' => '10036', 'address' => 'West 43rd Street, New York, NY 10036, United States', 'country_code' => 'US', 'cancellation_policy' => 'strict', 'property_type' => 'Apartment', 'room_type' => 'Entire home/apt' }
  end

  let(:listing_one) { create(:listing) }

  let(:result_two) do
    { 'id' => 900692, 'city' => 'New York', 'lat' => 40.75747813141989, 'lng' => -73.99101412904595, 'country' => 'United States', 'name' => 'Times Square, Queen Bed, Big Futon!', 'smart_location' => 'New York, NY', 'bedrooms' => 1, 'beds' => 1, 'neighborhood' => "Hell's Kitchen", 'person_capacity' => 4, 'state' => 'NY', 'zipcode' => '10036', 'address' => 'West 43rd Street, New York, NY 10036, United States', 'country_code' => 'US', 'cancellation_policy' => 'strict', 'property_type' => 'Apartment', 'room_type' => 'Entire home/apt' }
  end

  let(:listing_two) { create(:listing) }

  before do
    Listing.stub(:find_or_create_by).with({ :airbnb_id => result_one['id'] }).and_return(listing_one)
    listing_one.stub(:update_attributes! => true)
    Listing.stub(:find_or_create_by).with({ :airbnb_id => result_two['id'] }).and_return(listing_two)
    listing_two.stub(:update_attributes! => true)
    Airbnb::Listing.stub(:fetch => [ result_one, result_two ])
    subject.new.perform(attributes)
  end

  around do |example|
    Sidekiq::Testing.fake! do
      example.run
    end
  end

  it 'searches for listings by the provided options' do
    Airbnb::Listing.should have_received(:fetch).with(attributes)
  end

  it 'creates new listings from results' do
    Listing.should have_received(:find_or_create_by).with(:airbnb_id => result_one['id']).once
    Listing.should have_received(:find_or_create_by).with(:airbnb_id => result_two['id']).once
  end

  it 'updates the listings with the results' do
    listing_one.should have_received(:update_attributes!).with({
      :name                => result_one['name'],
      :city                => result_one['city'],
      :latitude            => result_one['lat'],
      :longitude           => result_one['lng'],
      :country             => result_one['country'],
      :smart_location      => result_one['smart_location'],
      :bedrooms            => result_one['bedrooms'],
      :beds                => result_one['beds'],
      :neighborhood        => result_one['neighborhood'],
      :person_capacity     => result_one['person_capacity'],
      :state               => result_one['state'],
      :zipcode             => result_one['zipcode'],
      :address             => result_one['address'],
      :country_code        => result_one['country_code'],
      :cancellation_policy => result_one['cancellation_policy'],
      :property_type       => result_one['property_type'],
      :room_type           => result_one['room_type']
    })

    listing_two.should have_received(:update_attributes!).with({
      :name                => result_two['name'],
      :city                => result_two['city'],
      :latitude            => result_two['lat'],
      :longitude           => result_two['lng'],
      :country             => result_two['country'],
      :smart_location      => result_two['smart_location'],
      :bedrooms            => result_two['bedrooms'],
      :beds                => result_two['beds'],
      :neighborhood        => result_two['neighborhood'],
      :person_capacity     => result_two['person_capacity'],
      :state               => result_two['state'],
      :zipcode             => result_two['zipcode'],
      :address             => result_two['address'],
      :country_code        => result_two['country_code'],
      :cancellation_policy => result_two['cancellation_policy'],
      :property_type       => result_two['property_type'],
      :room_type           => result_two['room_type']
    })
  end
end
