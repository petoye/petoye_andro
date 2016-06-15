class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string, array: true, default: []
  end
end
