class AddCameraToBoards < ActiveRecord::Migration[7.0]
  def change
    add_reference :boards, :camera, null: false, foreign_key: true
  end
end
