class AddDescriptionToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :description, :string
  end
end