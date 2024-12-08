class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  attr_accessor :password_confirmation

  # ユーザー名は新規登録時に必須
  validates :user_name, presence: true, length: { maximum: 255 }

  # パスワードのバリデーション
  validates :password, length: { minimum: 3, message: I18n.t('activerecord.errors.models.user.attributes.password.too_short') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password.confirmation') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: { message: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.blank') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.mismatch') }, if: -> { password.present? }

  # メールアドレス
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  has_many :boards, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_boards, through: :bookmarks, source: :board

  def bookmark(board)
    bookmark_boards << board
  end

  def unbookmark(board)
    bookmark_boards.destroy(board)
  end

  def bookmark?(board)
    bookmark_boards.include?(board)
  end

  def own?(board)
    board.user == self
  end
end
