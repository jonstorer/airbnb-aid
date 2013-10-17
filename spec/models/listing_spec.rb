require 'spec_helper'

describe Listing do
  it { should be_timestamped_document }

  it { should have_field(:airbnb_id).of_type(Integer) }
  it { should validate_presence_of(:airbnb_id) }
  it { should validate_uniqueness_of(:airbnb_id) }

  it { should have_field(:active).of_type(Boolean).with_default_value_of(true) }

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
  it { should have_field(:bathrooms).of_type(Integer) }
  it { should have_field(:person_capacity).of_type(Integer) }
  it { should have_field(:property_type) }
  it { should have_field(:room_type) }
  it { should have_field(:cancellation_policy) }
  it { should have_field(:min_nights).of_type(Integer) }
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
  subject { create(:listing) }

  around do |example|
    Sidekiq::Testing.fake! do
      example.run
    end
  end

  it 'schedules a job to update the listing' do
    ListingWorker.stub(:perform_async => true)
    subject.save!
    ListingWorker.should have_received(:perform_async).with(subject.to_param)
  end
end

describe Listing, 'after_update' do
  subject { create(:listing) }

  around do |example|
    Sidekiq::Testing.fake! do
      example.run
    end
  end

  Listing::WATCHED_FIELDS.each do |field|
    it "schedules a job to find similar listings when the #{field} field changes" do
      subject.stub("#{field}_changed?" => true)
      SimilarListingWorker.stub(:perform_async => true)
      subject.save!
      SimilarListingWorker.should have_received(:perform_async).with(subject.to_param)
    end
  end

  it 'does not schedule jobs when the listing is not active' do
    subject.stub(:active? => false)
    SimilarListingWorker.stub(:perform_async => true)
    subject.save!
    SimilarListingWorker.should_not have_received(:perform_async).with(subject.to_param)
  end

  it 'does not schedule jobs when any of the required fields are not present' do
    subject.stub(:city => nil)
    SimilarListingWorker.stub(:perform_async => true)
    subject.save!
    SimilarListingWorker.should_not have_received(:perform_async).with(subject.to_param)
  end
end
