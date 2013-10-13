require 'spec_helper'

describe SimilarListingWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    SimilarListingWorker.get_sidekiq_options['queue'].should == 'default'
  end
end

describe SimilarListingWorker, '#perform, it fetches similar listings' do
  subject { SimilarListingWorker }
  let(:listing) do
    create(:listing, {
      :beds            => 2,
      :bedrooms        => 2,
      :bathrooms       => 1,
      :person_capacity => 4,
      :room_type       => 'Entire home/apt',
      :smart_location  => 'Brooklyn, NY',
      :neighborhood    => 'Fort Greene'
    })
  end

  before do
    Airbnb::Listing.stub(:fetch => [])
    subject.new.perform(listing.id)
  end

  around do |example|
    Sidekiq::Testing.fake! do
      example.run
    end
  end


  [2,3,4,5,6].each do |guests|
    [1,2,3].each do |beds|
      [1,2,3].each do |bedrooms|
        [1, 2, 3, 4, 5].each do |page|
          it 'searches' do
            Airbnb::Listing.should have_received(:fetch).with({
              :number_of_guests => guests,
              :min_beds         => beds,
              :min_bedrooms     => bedrooms,
              :page             => page
            }).once
          end
        end
      end
    end
  end
end
