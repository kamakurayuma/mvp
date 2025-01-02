require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is invalid without a user_name' do
      user = User.new(user_name: nil, email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:user_name]).to include('ユーザー名を入力してください')
    end

    it 'is valid with a user_name' do
      user = User.new(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(user).to be_valid
    end
  end
end

