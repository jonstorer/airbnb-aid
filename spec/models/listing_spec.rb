require 'spec_helper'

describe Listing do
  it { should be_timestamped_document }

  it { should have_field(:airbnb_id) }
  it { should validate_presence_of(:airbnb_id) }

  it { should have_field(:name) }
  it { should have_field(:city) }
  it { should have_field(:state) }
  it { should have_field(:zipcode) }
  it { should have_field(:country_code) }
  it { should have_field(:smart_location) }
  it { should have_field(:neighborhood) }
  it { should have_field(:address) }
  it { should have_field(:latitude).of_type(Float) }
  it { should have_field(:longitude).of_type(Float) }
  it { should have_field(:bedrooms).of_type(Integer) }
  it { should have_field(:beds).of_type(Integer) }
  it { should have_field(:person_capacity).of_type(Integer) }
  it { should have_field(:property_type) }
  it { should have_field(:room_type) }
  it { should have_field(:cancellation_policy) }
end

describe Listing, '#name' do
  context 'when the name is set' do
    subject { Listing.new(:airbnb_id => 1, :name => 'My Listing') }
    its(:name) { should == 'My Listing' }
  end

  context 'when the name is not set' do
    subject { Listing.new(:airbnb_id => 1) }
    its(:name) { should == 'Listing 1' }
  end
end

describe Listing, 'after_create' do
  subject { build(:listing) }

  it 'schedules a job to update the listing' do
    ListingWorker.stub(:perform_async => true)
    subject.save!
    ListingWorker.should have_received(:perform_async).with(subject.to_param)
  end
end
