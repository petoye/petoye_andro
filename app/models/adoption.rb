class Adoption < ActiveRecord::Base
  validates :pet_type,:breed, :age, :description, presence: true

  belongs_to :user

  has_attached_file :image, styles: { original: "414x414>", thumb: "43x43>" }, default_url: "/images/:style/missing.png"
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 1.megabytes
  validates_with AttachmentPresenceValidator, attributes: :image
end
