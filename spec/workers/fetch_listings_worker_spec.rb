require 'spec_helper'

describe FetchListingsWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    FetchListingsWorker.get_sidekiq_options['queue'].should == 'default'
  end
end

describe FetchListingsWorker, '#perform, it fetches similar listings' do
  subject           { FetchListingsWorker }
  let(:attributes)  { { 'some' => 'params' } }
  let(:listing_one) { create(:listing) }
  let(:result_one)  { double('result 1', :id => 1) }
  let(:listing_two) { create(:listing) }
  let(:result_two)  { double('result 2', :id => 2) }
  let(:builder)     { double(:save! => true) }

  before do
    Listing.stub(:find_or_create_by).with({ :airbnb_id => result_one.id }).and_return(listing_one)
    Listing.stub(:find_or_create_by).with({ :airbnb_id => result_two.id }).and_return(listing_two)
    Airbnb::Listing.stub(:fetch => [ result_one, result_two ])
    ListingBuilder.stub(:new => builder)
    subject.new.perform(attributes)
  end

  it 'searching for listings with the supplied arguments' do
    Airbnb::Listing.should have_received(:fetch).with(attributes)
  end

  it 'finds or creates a listing from the results' do
    Listing.should have_received(:find_or_create_by).with({ :airbnb_id => result_one.id })
    Listing.should have_received(:find_or_create_by).with({ :airbnb_id => result_two.id })
  end

  it 'updates the listing with the ListingBuilder' do
    ListingBuilder.should have_received(:new).with(listing_one, result_one)
    builder.should have_received(:save!).twice
  end
end
