class RemoveLikedbyFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :likedby
  end
end
