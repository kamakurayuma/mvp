class CreateCameraModels < ActiveRecord::Migration[6.0]
  def change
    create_table :camera_models do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :camera_models, :name, unique: true  
  end
end