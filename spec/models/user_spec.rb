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

    it 'is invalid with a password shorter than 3 characters' do
      user = User.new(user_name: 'TestUser', email: 'test@example.com', password: '12', password_confirmation: '12')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.too_short'))
    end

    it 'is invalid if password confirmation does not match' do
      user = User.new(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'mismatch')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include(I18n.t('activerecord.errors.models.user.attributes.password_confirmation.mismatch'))
    end

    it 'is invalid without an email' do
        user = User.new(user_name: 'TestUser', email: nil, password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスを入力してください')
     end
      

    it 'is invalid with a duplicate email' do
      user1 = User.create(user_name: 'TestUser1', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      user2 = User.new(user_name: 'TestUser2', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(user2).not_to be_valid
      expect(user2.errors[:email]).to include("そのメールアドレスはすでに使用されています")
    end
  end

  describe 'methods' do
    it 'generates a random token' do
      token = User.new_token
      expect(token).not_to be_nil
      expect(token.length).to be > 0
    end

    it 'returns the hashed password' do
      password = 'password'
      digest = User.digest(password)
      expect(BCrypt::Password.new(digest)).to be_a(BCrypt::Password)
    end

    it 'remembers the user with a token' do
      user = User.create(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      user.remember
      expect(user.remember_token).not_to be_nil
      expect(user.remember_digest).not_to be_nil
    end

    it 'returns true if the token is authenticated' do
      user = User.create(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      user.remember
      expect(user.authenticated?(user.remember_token)).to be true
    end

    it 'forgets the user by deleting the remember_digest' do
      user = User.create(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      user.remember
      expect(user.remember_digest).not_to be_nil
      user.forget
      expect(user.remember_digest).to be_nil
    end
  end

  describe 'associations' do
    it 'has many boards' do
      user = User.new(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      board = user.boards.build(title: 'Sample Board')
      expect(user.boards).to include(board)
    end

    it 'has many bookmarks' do
      user = User.new(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      board = Board.create(title: 'Sample Board')
      user.bookmark(board)
      expect(user.bookmark_boards).to include(board)
    end

    it 'can unbookmark a board' do
        user = User.create(user_name: 'TestUser', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'sample.jpg'), 'image/jpeg')
      
        board = Board.create(
          title: 'Sample Board',
          camera_make: 'Canon',
          camera_model: 'EOS',
          board_image: file,
          camera: Camera.create(make: 'Canon', model: 'EOS'),
          user: user
        )
      
        user.bookmark(board)
        expect(user.bookmark_boards).to include(board)
      
        user.unbookmark(board)
        expect(user.bookmark_boards).not_to include(board)
    end      
  end
end
