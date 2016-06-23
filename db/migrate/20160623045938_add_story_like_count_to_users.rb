class AddStoryLikeCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :story_like_count, :integer, default: 0
  end
end
