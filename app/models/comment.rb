class Comment < ActiveRecord::Base
  before_create :set_previous_state
  after_create :set_ticket_state

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

end
