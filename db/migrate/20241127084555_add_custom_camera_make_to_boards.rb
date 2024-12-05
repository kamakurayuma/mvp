class AddCustomCameraMakeToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :custom_camera_make, :string
  end
end
