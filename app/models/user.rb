class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :salt
  field :remember_me_token
  attr_accessor :password
  field :encrypted_password

  validates :password,           :confirmation => true, :unless => 'password.blank?'
  validates :password,           :presence     => { :message => 'is required' }, :if => :new_record?
  validates :encrypted_password, :presence     => { :message => 'is required' }
  validates :email,              :presence     => { :message => 'is required' }
  validates :salt,               :presence     => true
  validates :remember_me_token,  :presence     => true

  before_validation :set_encryped_password, :on => :create, :unless => 'password.blank?'
  before_validation :set_remember_me_token, :on => :create

  has_and_belongs_to_many :listings, :inverse_of => nil

  def password_matches?(guess)
    encrypted_password == encrypt(guess)
  end

  def reset_remember_me_token!
    set_remember_me_token
    save!
  end

  private

  def set_remember_me_token
    self.remember_me_token = encrypt("#{Time.now.to_i}--#{SecureRandom.hex}")
  end

  def set_encryped_password
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    digest("#{salt}--#{string}--")
  end

  def salt
    attributes['salt'] || write_attribute(:salt, digest("--#{Time.now.utc}--#{Kernel.rand}--#{password}--"))
    attributes['salt']
  end

  def digest(string)
    Digest::SHA1.hexdigest(string)
  end
end
