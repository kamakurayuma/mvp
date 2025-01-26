class AddBoardImageUrlToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :board_image_url, :string
  end
end
