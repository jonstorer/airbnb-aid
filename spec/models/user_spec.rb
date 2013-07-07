require 'spec_helper'

describe User do
  it { should have_field(:email) }
  it { should have_field(:aid).of_type(Integer) }

  it { should have_field(:password) }
  it { should validate_confirmation_of(:password) }

  it { should have_field(:first_name) }
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

  it 'updates the user record from airbnb' do
    subject.first_name.should be_nil
    subject.save!
    subject.first_name.should == 'Jane'
  end
end
