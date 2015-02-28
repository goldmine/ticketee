require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, name: 'Tickettee') }
  let!(:ticket) { FactoryGirl.create(:ticket, title: 'state trans',
                                    description: 'cannot be hacked',
                                    user: user, project: project) }
  let!(:state) { FactoryGirl.create(:state, name: 'New') }

  context 'user without permission to set state' do
    before do
      sign_in(user)
    end

    it 'cannot change state by passing through state_id' do
      post :create, { comment: { text: 'hacked', state_id: state.id },
                                 ticket_id: ticket.id }
      ticket.reload
      expect(ticket.state).to eql(nil)
    end
  end

  context 'user with permission can set state' do
    before do
      define_permission(user, :"change states", project)
      sign_in(user)
    end

    it 'can change state by passing through state_id' do
      post :create, { comment: { text: 'hacked', state_id: state.id },
                                 ticket_id: ticket.id }
      ticket.reload
      expect(ticket.state).to eql(state)
    end
  end


end
