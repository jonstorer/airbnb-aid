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

describe AvailabilityWorker, '#perform' do
  subject       { AvailabilityWorker.new }
  let(:params)  { { :id => listing.to_param, :checkin => '11/12/2013', :checkout => '13/12/2013' } }
  let(:listing) { create(:listing, :airbnb_id => 1234, :person_capacity => 2) }
  let(:airbnb_listing) { double('airbnb_listing', :available? => true) }

  before do
    Airbnb::Listing.stub(:find).and_return(airbnb_listing)
    subject.perform(params)
  end

  it 'fetches the listings availability for the given dates' do
    airbnb_listing.should have_received(:available?).
      with(Date.parse(params[:checkin]), Date.parse(params[:checkout]), listing.person_capacity)
  end
end
