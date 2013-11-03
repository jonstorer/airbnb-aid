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
  subject       { AvailabilityWorker.new }
  let(:params)  { { :id => listing.to_param, :checkin => '11/12/2013', :checkout => '13/12/2013' } }
  let(:listing) { create(:listing, :airbnb_id => 1234, :person_capacity => 2) }

  before do
    $airbnb_api['/api/-/v1/listings/1234'] = {
      :listing => { :id => 1234, :person_capacity => 2, :min_nights => 2, :max_nights => 7 }
    }
    $airbnb_api['/api/-/v1/listings/1234/available'] = {
      :result => { :available => true, :price => 52, :price_native => 54, :native_currency => 'USD', :service_fee => '$6', :price_formatted => '$54' }
    }
    subject.perform(params)
  end

  it 'fetches the listings availability for the given dates' do
    airbnb_listing.should have_received(:available?).with({
      :checkin          => params[:checkin],
      :checkout         => params[:checkout],
      :number_of_guests => listing.person_capacity
    })
  end

  it 'creates an availability for the listing' do
    pending 'woo'
    #airbnb_listing.should have_received(:available?).with({
      #:checkin  => params[:checkin],
      #:checkout => params[:checkout]
    #})
  end
end
