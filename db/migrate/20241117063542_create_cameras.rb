class CreateCameras < ActiveRecord::Migration[7.0]
  def change
    create_table :cameras do |t|
      t.string :make
      t.string :model
      t.boolean :unknown

      t.timestamps
    end
  end
end
