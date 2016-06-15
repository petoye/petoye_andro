class AdduserTypetoUsers < ActiveRecord::Migration
  
  def change
   add_column :users, :owner_type, :string, default: "none"
  end
end
