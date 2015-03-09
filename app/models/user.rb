class User < ActiveRecord::Base
  before_create :create_auth_token
  has_secure_password
  has_many :tickets
  has_many :permissions
  has_many :comments
  validates :email, presence: true

  def self.reset_request_count
    update_all("request_count = 0 where request_count > 0")
  end

  def to_s
    "#{email} (#{admin ? "Admin" : "User"})"
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column == self[column])
  end

  def create_auth_token
    generate_token(:auth_token)
  end

end
