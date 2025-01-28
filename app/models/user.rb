class User < ApplicationRecord
  authenticates_with_sorcery!


  attr_accessor :password_confirmation
  attr_accessor :remember_token

  validates :user_name, presence: { message: 'ユーザー名を入力してください' }

  validates :password, length: { minimum: 3, message: I18n.t('activerecord.errors.models.user.attributes.password.too_short') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password.confirmation') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: { message: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.blank') }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: { message: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.mismatch') }, if: -> { password.present? }

  validates :email, presence: true, uniqueness: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  validates :bio, length: { maximum: 160, message: '自己紹介文は160文字以内で入力してください' }

  has_many :boards, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_boards, through: :bookmarks, source: :board

  has_one_attached :avatar

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

  def self.new_token 
    SecureRandom.urlsafe_base64
  end

  def self.digest(string) 
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil? 
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.from_omniauth(id_token)
    user_info = get_google_user_info(id_token)
  
    user = User.find_by(email: user_info[:email])
    return user if user
  
    password = SecureRandom.hex(10) 
    new_user = User.new(
      email: user_info[:email],
      user_name: user_info[:name],
      password: password,
      password_confirmation: password 
    )
  
    if new_user.save
      return new_user
    else
      Rails.logger.error("User creation failed: #{new_user.errors.full_messages.join(', ')}")
      return nil
    end
  end
  
  private

  def self.get_google_user_info(id_token)
    response = RestClient.get("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{id_token}")
    JSON.parse(response.body).symbolize_keys
  end
end
