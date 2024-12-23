require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Userモデルのバリデーションのテスト" do
    # ユーザー名がない場合
    it "ユーザー名が空であれば無効であること" do
      user = User.new(user_name: nil)
      user.valid? 
      expect(user.errors[:user_name]).to include('ユーザー名を入力してください')
    end

    # ユーザー名がある場合
    it "ユーザー名が入力されていれば有効であること" do
      user = User.new(user_name: 'Test User')
      expect(user).to be_valid
    end
  end
end
