class AddCommentToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :comment, :string, array: true, default: []
  end
end
