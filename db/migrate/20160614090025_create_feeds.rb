class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :message
      t.integer :like_count, default: 0
      t.integer :comment_count, default: 0
      t.integer :user_id, default: nil

      t.timestamps 
    end
    add_index :feeds, :user_id
  end
end
