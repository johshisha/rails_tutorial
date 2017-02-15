class AddColumnToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :userid, :string, unique: true
  end
  
  def down
    remove_column :users, :userid
  end
end
