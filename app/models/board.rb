class Board < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :camera_make, :camera_model, presence: true
  validates :custom_camera_make, presence: true, if: :other_camera_make?
  validates :board_image, presence: true
  
    
    belongs_to :camera
    belongs_to :user

    paginates_per 30

    mount_uploader :board_image, BoardImageUploader

    def self.ransackable_attributes(auth_object = nil)
        [
          "board_image", "body", "camera_id", "camera_make", "camera_model", 
          "created_at", "id", "image_url", "title", "updated_at", "user_id"
        ]
      end
    
      def self.ransackable_associations(auth_object = nil)
        ["camera", "user"]  # 検索可能な関連をここで定義
      end

      before_validation :set_camera_id, on: [:create, :update]

    private

    def set_camera_id
      return if camera_make.blank? || camera_model.blank?
  
      camera = Camera.find_or_create_by(make: camera_make, model: camera_model)
      self.camera_id = camera.id
    end

    def other_camera_make?
      camera_make == "その他"
    end

      def custom_camera_make_if_other
    if camera_make == 'その他' && custom_camera_make.blank?
      errors.add(:custom_camera_make, 'カメラのメーカー名を入力してください')
    end
  end

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