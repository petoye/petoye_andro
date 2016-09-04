class AddFollowersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followers, :int, default: 0
  end
end
