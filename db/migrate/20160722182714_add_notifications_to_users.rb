class AddNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications, :string, array: true, default: []
  end
end