class Comment < ActiveRecord::Base
  before_create :set_previous_state
  after_create :set_ticket_state,
               :creator_watches_ticket,
               :comment_notification

  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  belongs_to :previous_state, class_name: 'State'
  validates :text, presence: true

  delegate :project, to: :ticket

  private
  def set_ticket_state
    self.ticket.state = self.state
    self.ticket.save!
  end
  def set_previous_state
    self.previous_state = self.ticket.state
  end
  def creator_watches_ticket
    self.ticket.watchers << self.user
  end
  def comment_notification
    (self.ticket.watchers - [self.user]).each do |user|
      Notifier.comment_updated(self, user).deliver_now
    end
  end

end
