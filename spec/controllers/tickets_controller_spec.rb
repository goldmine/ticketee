require 'rails_helper'

RSpec.describe TicketsController, :type => :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) { FactoryGirl.create(:ticket,
                                     project: project,
                                     user: user) }
  context 'standard user' do
    it 'can not access ticket for a project' do
      sign_in(user)
      get :show, id: ticket.id, project_id: project.id

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eql('The project could not be found')
    end
  end

  context 'with permission to view the project' do
    before do
      sign_in(user)
      define_permission(user, 'view', project)
    end

    it 'can not start to create a ticket' do
      get :new, project_id: project.id
      expect(response).to redirect_to(project_path(project))
      expect(flash[:alert]).to eql('you do not have permission!')
    end

    it 'can not create a ticket' do
      post :create, project_id: project.id
      expect(response).to redirect_to(project_path(project))
      expect(flash[:alert]).to eql('you do not have permission!')
    end

    it 'can not start to edit a ticket' do
      get :edit, id: ticket.id, project_id: project.id
      expect(response).to redirect_to(project_path(project))
      expect(flash[:alert]).to eql('you do not have permission!')
    end

    it 'can not update a ticket' do
      put :update, { id: ticket.id, project_id: project.id, ticket: {} }
      expect(response).to redirect_to(project_path(project))
      expect(flash[:alert]).to eql('you do not have permission!')
    end
  end


end
