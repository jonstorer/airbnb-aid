require 'spec_helper'

describe Report do
  it { should be_timestamped_document }
  it { should belong_to(:listing) }

  Timecop.freeze do
    it { should have_field(:reported_at).of_type(DateTime) }
    its(:reported_at) { should === DateTime.now.utc }
  end
end
