require 'spec_helper'

describe ListingWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    ListingWorker.get_sidekiq_options['queue'].should == 'default'
  end
end

describe ListingWorker, '#perform, it updated the record from airbnb' do
  subject          { listing.reload }
  let(:listing)    { create(:listing) }
  let(:api_response) do
    {
      :listing               => {
        :name                => 'Fort Greene 1 br',
        :city                => 'Brooklyn',
        :zipcode             => '11205',
        :country_code        => 'US',
        :smart_location      => 'Brooklyn, NY',
        :neighborhood        => 'Fort Greene',
        :address             => 'Clermont Ave, Brooklyn, NY 11205',
        :lat                 => 72.49,
        :lng                 => 49.72,
        :bedrooms            => 1,
        :beds                => 2,
        :person_capacity     => 4,
        :property_type       => 'Apartment',
        :room_type           => 'Entire home/apt',
        :cancellation_policy => 'strict'
      }
    }
  end

  before do
    $airbnb_api["/api/-/v1/listings/#{listing.airbnb_id}"] = api_response
    ListingWorker.new.perform(listing.id)
  end

  around do |example|
    Sidekiq::Testing.fake! do
      example.run
    end
  end

  its(:name)                { should == 'Fort Greene 1 br' }
  its(:city)                { should == 'Brooklyn' }
  its(:zipcode)             { should == '11205' }
  its(:country_code)        { should == 'US' }
  its(:smart_location)      { should == 'Brooklyn, NY' }
  its(:neighborhood)        { should == 'Fort Greene' }
  its(:address)             { should == 'Clermont Ave, Brooklyn, NY 11205' }
  its(:latitude)            { should == 72.49 }
  its(:longitude)           { should == 49.72 }
  its(:bedrooms)            { should == 1 }
  its(:beds)                { should == 2 }
  its(:person_capacity)     { should == 4 }
  its(:property_type)       { should == 'Apartment' }
  its(:room_type)           { should == 'Entire home/apt' }
  its(:cancellation_policy) { should == 'strict' }
end
