require 'spec_helper'

describe AvailabilityParentWorker do
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
  subject       { AvailabilityParentWorker.new }
  let(:listing) { create(:listing, :min_nights => 2) }

  before do
    Listing.stub(:find).with(listing.to_param).and_return(listing)
  end

  around(:each) do |example|
    Timecop.freeze(Time.now) do
      example.run
    end
  end

  it 'schedules jobs to fetch availibility over the next 30 days' do
    AvailabilityParentWorker.stub(:perform_async)
    subject.perform(listing.to_param)
    (0..30).each do |n|
      AvailabilityParentWorker.should have_received(:perform_async).with({
        :id       => listing.to_param,
        :checkin  => n.days.from_now.to_date,
        :checkout => (n + 2).days.from_now.to_date
      })
    end
  end
end
