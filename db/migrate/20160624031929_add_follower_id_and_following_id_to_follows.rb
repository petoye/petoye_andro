class AddFollowerIdAndFollowingIdToFollows < ActiveRecord::Migration
  def change
    add_column :follows, :follower_id, :integer
    add_column :follows, :following_id, :integer
  end
end
