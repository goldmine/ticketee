require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'passwords' do
    it 'needs a password and confirmation to save' do
      u = User.new(name: 'steve',
                   email: 'steve@test.com')
      u.save
      expect(u).to_not be_valid

      u.password = 'password'
      u.password_confirmation = ''
      u.save
      expect(u).to_not be_valid

      u.password_confirmation = 'password'
      u.save
      expect(u).to be_valid
    end

    it 'needs password and confirmation to match' do
      u = User.create(name: 'steve',
                      password: 'hunter2',
                      password_confirmation: 'hunter')
      expect(u).to_not be_valid
    end
  end

  describe 'authentication' do
    let(:user) { User.create(name: 'steve',
                             password: 'hunter2',
                             password_confirmation: 'hunter2') }
    it 'authenticate with a correct password' do
      expect(user.authenticate('hunter2')).to be
    end
    it 'authenticate with a incorrect password' do
      expect(user.authenticate('hunter1')).to_not be
    end
  end

  describe 'email' do
    it 'requires an email' do
      u = User.new(name: 'steve',
                   password: 'hunter2',
                   password_confirmation: 'hunter2')

      u.save
      expect(u).to_not be_valid
      u.email = 'steve@test.com'
      expect(u).to be_valid
    end
  end

  describe 'request_count' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'resets user requrest count' do
      user.update_attributes({"request_count" => 42})
      User.reset_request_count
      user.reload
      expect(user.request_count).to eql(0)
    end
  end
end




