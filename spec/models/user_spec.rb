require 'spec_helper'

describe User do
  it { should be_timestamped_document }

  it { should have_field(:email) }
  it { should validate_presence_of(:email) }

  it { should validate_confirmation_of(:password) }
  it { should validate_presence_of(:password) }

  it { should have_field(:encrypted_password) }
  it { should validate_presence_of(:encrypted_password) }

  it { should have_and_belong_to_many(:listings).as_inverse_of(nil) }
end

describe User, '#password' do
  context 'persisted record' do
    subject { create(:user) }
    it 'does not require the password to be set or confirm the password' do
      subject.password = nil
      subject.should be_valid
    end
  end
end

describe User, 'set_encrypted_password' do
  before { Kernel.stub(:rand => 0.5) }

  around do |example|
    Timecop.freeze do
      example.run
    end
  end

  context 'when password and confirmation are present' do
    subject { create(:user, :password => 'test', :password_confirmation => 'test') }

    its(:encrypted_password) do
      salt = Digest::SHA1.hexdigest("--#{ Time.now.utc }--#{ Kernel.rand }--test--")
      should == Digest::SHA1.hexdigest("#{ salt }--test--")
    end
  end

  context 'when password and confirmation are not present' do
    subject { build(:user, :password => '', :password_confirmation => '') }
    before  { subject.valid? }

    its(:encrypted_password) { should be_nil }
  end
end

describe User, '#password_matches?' do
  subject { create(:user, :password => 'unknown', :password_confirmation => 'unknown') }

  it 'returns true if the provided password matches' do
    subject.password_matches?('unknown').should be_true
  end

  it 'returns false if the provided password does not match' do
    subject.password_matches?('known').should be_false
  end
end
