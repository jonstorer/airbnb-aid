class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  attr_accessor :password
  field :encrypted_password
  field :airbnb_user_id, :type => Integer
  field :first_name

  validates :password,           :confirmation => true
  validates :password,           :presence     => { :message => 'is required' }
  validates :encrypted_password, :presence     => { :message => 'is required' }
  validates :airbnb_user_id,     :presence     => { :message => 'is required' }
  validates :email,              :presence     => { :message => 'is required' }

  before_validation :set_encryped_password, :on => :create, :unless => 'password.blank?'
  before_create :update_from_airbnb

  def password_matches?(guess)
    encrypted_password == encrypt(guess)
  end

  private

  def set_encryped_password
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    digest("#{salt}--#{string}--")
  end

  def salt
    attributes['salt'] ||= digest("--#{Time.now.utc}--#{Kernel.rand}--#{password}--")
  end

  def digest(string)
    Digest::SHA1.hexdigest(string)
  end

  def update_from_airbnb
    write_attributes({
      :first_name => airbnb_user.first_name
    })
  end

  def airbnb_user
    @airbnb_user ||= Airbnb::User.find(airbnb_user_id)
  end
end
