class Feed < ActiveRecord::Base
  validates :message, :like_count, :comment_count, :user_id, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  #serialize :comment, Array
  #serialize :likedby, Array
  #serialize :report, Array
  #validates :user_id, presence: true
  has_attached_file :image, styles: { medium: "414x414>", thumb: "43x43>" }, default_url: "/images/:style/missing.png"
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 1.megabytes
  validates_with AttachmentPresenceValidator, attributes: :image
end
