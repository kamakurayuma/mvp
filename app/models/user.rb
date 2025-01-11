class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  attr_accessor :password_confirmation
  attr_accessor :remember_token

  # ユーザー名は新規登録時に必須
  validates :user_name, presence: { message: 'ユーザー名を入力してください' }

  # パスワードのバリデーション
  validates :password, length: { minimum: 3, message: I18n.t('activerecord.errors.models.user.attributes.password.too_short') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password.confirmation') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: { message: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.blank') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.mismatch') }, if: -> { password.present? }

  # メールアドレス
  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  # 自己紹介文
  validates :bio, length: { maximum: 160, message: '自己紹介文は160文字以内で入力してください' }

  has_many :boards, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_boards, through: :bookmarks, source: :board

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

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
  
  # ランダムなトークンを返す
  def self.new_token # User.new_tokenと同じ意味
    SecureRandom.urlsafe_base64
  end

  # 与えられた文字列のハッシュ値を返す
  def self.digest(string) # User.digest(string)を同じ意味
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 永続的セッションで使用するユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil? 
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end
