class AddSmallImageUrlToAdoptions < ActiveRecord::Migration
  def change
    add_column :adoptions, :smallimageurl, :string
  end
end
