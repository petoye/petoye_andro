class Follow < ActiveRecord::Base
  validates :follower_id, :following_id, presence: true
  belongs_to :user
end
