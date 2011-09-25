class AddEmailToUser < ActiveRecord::Migration
  def up
    add_column :users, :email, :string
  end
  
  def down
    remove_column :users, :email, :string
  end
end
