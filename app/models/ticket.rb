class Ticket < ActiveRecord::Base
  validates :title, :description, presence: true
  validates :description, length: { minimum: 10 }
  belongs_to :project
  belongs_to :user
  belongs_to :state
  has_many :assets
  has_many :comments
  accepts_nested_attributes_for :assets
end
