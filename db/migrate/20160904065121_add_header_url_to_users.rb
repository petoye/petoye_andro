class AddHeaderUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :headerurl, :string
  end
end
