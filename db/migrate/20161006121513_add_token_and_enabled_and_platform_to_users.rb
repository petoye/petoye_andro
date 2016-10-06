class AddTokenAndEnabledAndPlatformToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :enabled, :boolean
    add_column :users, :platform, :string
  end
end
