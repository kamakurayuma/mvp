class ChangeUsersCryptedPasswordAndSalt < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :crypted_password, true
    change_column_null :users, :salt, true
  end
end
