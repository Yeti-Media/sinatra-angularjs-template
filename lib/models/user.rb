class User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :email, :password, :password_confirmation, :current_password
  attr_accessor :password, :password_confirmation, :current_password

  field :email, type: String
  field :password_salt, type: String
  field :password_hash, type: String
  field :access_token, type: String

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  before_create :generate_token
  before_save :encrypt_password
  
  def self.authenticate(email, password)
    user = where(email: email).first
    if user && user.password_match?(password)
      user
    else
      nil
    end
  end
 

  def update_password(data)
    attributes = data
    if password_match?(current_password)
      save
    else
      self.errors.add(:current_password, 'is not valid')
      false
    end
  end


  def update_token
    generate_token
    save
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end 

  def generate_token
    self.access_token = rand(36**24).to_s(36)
  end


  def json_public
    {email: email,
     access_token: access_token}
  end

  def password_match?(password)
    password_hash == BCrypt::Engine.hash_secret(password, password_salt)
  end

end
