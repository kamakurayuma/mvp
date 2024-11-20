class Board < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :camera_make, :camera_model, presence: true
    # validate :board_image_size
  
    belongs_to :user

    mount_uploader :board_image, BoardImageUploader

    private

#   def board_image_size
#     return unless board_image.present?

#     # MiniMagickを使って画像の画素数を取得
#     image = MiniMagick::Image.read(board_image.download)
#     pixel_count = image.width * image.height

#     if pixel_count > 17_000_000
#       errors.add(:board_image, "は1700万画素以下である必要があります")
#     end
#   end
end