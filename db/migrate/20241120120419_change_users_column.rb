class ChangeUsersColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :email_address, :name
    add_column :users, :permission, :string
  end
end