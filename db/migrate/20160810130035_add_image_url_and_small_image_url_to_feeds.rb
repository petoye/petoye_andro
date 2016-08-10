class AddImageUrlAndSmallImageUrlToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :imageurl, :string
    add_column :feeds, :smallimageurl, :string
  end
end
