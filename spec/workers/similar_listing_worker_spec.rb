require 'spec_helper'

describe SimilarListingWorker do
  it { should be_kind_of(Sidekiq::Worker) }

  it 'has the default queue' do
    SimilarListingWorker.get_sidekiq_options['queue'].should == 'default'
  end
end

describe SimilarListingWorker, '#perform, it fetches similar listings' do
  subject { SimilarListingWorker }
  let(:location)  { "#{listing.neighborhood}, #{listing.smart_location}" }
  let(:room_type) { [ listing.room_type ] }
  let(:listing) do
    create(:listing, {
      :person_capacity => 4,
      :beds            => 2,
      :bedrooms        => 2,
      :bathrooms       => 1,
      :room_type       => 'Entire home/apt',
      :smart_location  => 'Brooklyn, NY',
      :neighborhood    => 'Fort Greene'
    })
  end

  around do |example|
    Sidekiq::Testing.fake! do
      example.run
    end
  end


  [2,3,4,5,6].each do |guests|
    [1,2,3].each do |beds|
      [1,2,3].each do |bedrooms|
        [1,2].each do |bathrooms|
          [1, 2, 3, 4, 5].each do |page|
            it "for #{guests} guests, #{beds} beds, #{bedrooms} bedrooms, #{bathrooms} bathrooms on page #{page}" do
              FetchListingsWorker.stub(:perform_async => true)
              subject.new.perform(listing.id)
              FetchListingsWorker.should have_received(:perform_async).with({
                :location         => location,
                :room_type        => room_type,
                :number_of_guests => guests,
                :min_beds         => beds,
                :min_bedrooms     => bedrooms,
                :min_bathrooms    => bathrooms,
                :page             => page
              }).once
            end
          end
        end
      end
    end
  end
end
