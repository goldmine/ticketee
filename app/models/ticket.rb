class Ticket < ActiveRecord::Base

  after_create :creator_watches_me

  validates :title, :description, presence: true
  validates :description, length: { minimum: 10 }
  belongs_to :project
  belongs_to :user
  belongs_to :state
  has_many :assets
  has_many :comments
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :watchers, join_table: "ticket_watchers",
                                     class_name: "User"
  accepts_nested_attributes_for :assets

  searcher do
    label :tag, :from => :tags, :field => 'name'
  end

  private
  def creator_watches_me
    if user
      self.watchers << user unless self.watchers.include?(user)
    end
  end
end
