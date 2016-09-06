class AddNotifsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications, :string
  end
end
