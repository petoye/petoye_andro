class Feed < ActiveRecord::Base
  validates :message, :like_count, :comment_count, :user_id, presence: true
  belongs_to :user
  serialize :comment, Array

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 1.megabytes
  validates_with AttachmentPresenceValidator, attributes: :image
end
