class AddFollowerNoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followerno, :string
  end
end
