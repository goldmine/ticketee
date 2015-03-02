class Ticket < ActiveRecord::Base

  validates :title, :description, presence: true
  validates :description, length: { minimum: 10 }
  belongs_to :project
  belongs_to :user
  belongs_to :state
  has_many :assets
  has_many :comments
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :assets

  searcher do
    label :tag, :from => :tags, :field => 'name'
  end

end
