require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'validations' do
    it 'is invalid without a title' do
      board = Board.new(title: nil, camera_make: 'Canon', camera_model: 'EOS', board_image: 'sample.jpg')
      expect(board).not_to be_valid
      expect(board.errors[:title]).to include("タイトルを入力してください")
    end

    it 'is invalid without a camera_make' do
      board = Board.new(title: 'Sample Board', camera_make: nil, camera_model: 'EOS', board_image: 'sample.jpg')
      expect(board).not_to be_valid
      expect(board.errors[:camera_make]).to include("カメラのメーカーを選択してください")
    end

    it 'is invalid without a camera_model' do
      board = Board.new(title: 'Sample Board', camera_make: 'Canon', camera_model: nil, board_image: 'sample.jpg')
      expect(board).not_to be_valid
      expect(board.errors[:camera_model]).to include("カメラの機種を入力してください")
    end

    it 'is invalid if custom_camera_make is blank when camera_make is "その他"' do
      board = Board.new(title: 'Sample Board', camera_make: 'その他', custom_camera_make: '', camera_model: 'EOS', board_image: 'sample.jpg')
      expect(board).not_to be_valid
      expect(board.errors[:custom_camera_make]).to include("カメラのメーカーを入力してください")
    end

    it 'is invalid without a board_image' do
      board = Board.new(title: 'Sample Board', camera_make: 'Canon', camera_model: 'EOS')
      expect(board).not_to be_valid
      expect(board.errors[:board_image]).to include("写真か動画を選択してください")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = Board.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a camera' do
      association = Board.reflect_on_association(:camera)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many bookmarks' do
      association = Board.reflect_on_association(:bookmarks)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'methods' do
    it 'sets camera_id before validation' do
      camera = Camera.create(make: 'Canon', model: 'EOS')
      board = Board.new(title: 'Sample Board', camera_make: 'Canon', camera_model: 'EOS')
      board.valid?
      expect(board.camera_id).to eq camera.id
    end
  end
end
