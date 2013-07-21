class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :password
  field :airbnb_user_id, :type => Integer
  field :first_name

  validates :password,       :confirmation => true
  validates :password,       :presence     => { :message => 'is required' }
  validates :airbnb_user_id, :presence     => { :message => 'is required' }
  validates :email,          :presence     => { :message => 'is required' }

  before_create :update_from_airbnb

  def password_matches?(guess)
    password == guess
  end

  private

  def update_from_airbnb
    write_attributes({
      :first_name => airbnb_user.first_name
    })
  end

  def airbnb_user
    @airbnb_user ||= Airbnb::User.find(airbnb_user_id)
  end
end
