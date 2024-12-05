class AddCameraModelToBoards < ActiveRecord::Migration[6.0]
  def change
    add_reference :boards, :camera_model, foreign_key: true
  end
end
