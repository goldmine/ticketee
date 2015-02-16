class User < ActiveRecord::Base
  has_secure_password
  has_many :tickets
  has_many :permissions
  has_many :comments
  validates :email, presence: true


  def to_s
    "#{email} (#{admin ? "Admin" : "User"})"
  end
end
