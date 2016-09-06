class AddNotifyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify, :string, array: true, default: []
  end
end
