class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :password
  field :airbnb_user_id, :type => Integer
  field :first_name

  validates :password, confirmation: true

  before_create :update_from_airbnb

  def password_matches?(guess)
    password == guess
  end

  private

  def update_from_airbnb
    airbnb_user = Airbnb::User.find(airbnb_user_id)
    write_attributes({
      :first_name => airbnb_user.first_name
    })
  end
end
