require 'spec_helper'

describe User do
  it { should have_field(:email) }
  it { should validate_presence_of(:email) }

  it { should have_field(:airbnb_user_id).of_type(Integer) }
  it { should validate_presence_of(:airbnb_user_id) }

  it { should validate_confirmation_of(:password) }
  it { should validate_presence_of(:password) }

  it { should have_field(:encrypted_password) }
  it { should validate_presence_of(:encrypted_password) }

  it { should have_field(:first_name) }
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

    its(:encrypted_password) do
      subject.valid?
      should be_nil
    end
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

describe User, 'after_create' do
  subject { build(:user) }

  before do
    response = { :user => { :id => subject.airbnb_user_id, :first_name => 'Jane' } }.to_json
    $airbnb_mock["/api/v1/users/#{subject.airbnb_user_id}"] = [ 200, { "Content-length" => response.size }, [ response ] ]
  end

  it 'updates the user record from airbnb' do
    subject.first_name.should be_nil
    subject.save!
    subject.first_name.should == 'Jane'
  end
end
