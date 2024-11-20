class AddCameraDetailsToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :camera_make, :string
    add_column :boards, :camera_model, :string
  end
end
