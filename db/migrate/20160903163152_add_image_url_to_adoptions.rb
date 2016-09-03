class AddImageUrlToAdoptions < ActiveRecord::Migration
  def change
    add_column :adoptions, :imageurl, :string
  end
end
