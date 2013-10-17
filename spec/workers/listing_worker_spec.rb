require 'spec_helper'

describe ListingWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    ListingWorker.get_sidekiq_options['queue'].should == 'high'
  end
end

describe ListingWorker, '#perform, it updated the record from airbnb' do
  let(:listing)        { create(:listing) }
  let(:builder)        { double(:save! => true) }
  let(:airbnb_listing) { double('airbnb_listing') }

  it 'should update the listing with the airbnb record' do
    Sidekiq::Testing.fake! do
      Airbnb::Listing.stub(:find => airbnb_listing)
      ListingUpdater.stub(:new => builder)
      ListingWorker.new.perform(listing.id)
      ListingUpdater.should have_received(:new).with(listing, airbnb_listing)
      builder.should have_received(:save!)
    end
  end
end
