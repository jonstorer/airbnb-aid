require 'spec_helper'

describe AvailabilityWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    subject.class.get_sidekiq_options['queue'].should == 'default'
  end

  it 'is setup to retry' do
    subject.class.get_sidekiq_options['retry'].should be_true
  end

  it 'is throttled correctly' do
    subject.class.get_sidekiq_options['throttle'][:threshold].should == 1
    subject.class.get_sidekiq_options['throttle'][:period].should == 8.seconds
  end
end

describe AvailabilityParentWorker, '#perform' do
  subject              { AvailabilityWorker.new }
  let(:params)         { { :id => listing.to_param, :checkin => '12/11/2013', :checkout => '12/13/2013' } }
  let(:listing)        { create(:listing) }
  let!(:airbnb_listing) { Airbnb::Listing.new(:id => listing.airbnb_id, :min_nights => listing.min_nights) }

  it 'fetches the listings availability for the given dates' do
    Airbnb::Listing.stub(:new).and_return(airbnb_listing)
    airbnb_listing.stub(:available?)
    subject.perform(params)
    airbnb_listing.should have_received(:available?).with({
      :checkin  => params[:checkin],
      :checkout => params[:checkout]
    })
  end
end
