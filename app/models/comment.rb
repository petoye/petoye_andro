class Comment < ActiveRecord::Base
  validates :comment_message, :post_id, :user_id, presence: true
  belongs_to :feed
  belongs_to :user
end
