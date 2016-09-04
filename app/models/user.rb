class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 before_create :generate_authentication_token!
 has_many :products , dependent: :destroy
 has_many :feeds, dependent: :destroy
 has_many :comments, dependent: :destroy
 has_many :adoptions, dependent: :destroy
 has_many :follows, dependent: :destroy
 has_many :conversations, dependent: :destroy
 has_many :messages, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 validates :auth_token, uniqueness: true
 validates :owner_type ,presence: true
 #serialize :notifications, Array
 validates_length_of :pet_story, maximum: 300
 acts_as_mappable

  has_attached_file :profilepic, styles: { original: "138x138>", thumb: "55x55>" }, default_url: "/images/:style/missing.png"
  validates_attachment :profilepic, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  #validates_with AttachmentSizeValidator, attributes: :profilepic, less_than: 1.megabytes
  validates_with AttachmentPresenceValidator, attributes: :profilepic

  has_attached_file :header, styles: { original: "185x185>" }, default_url: "/images/:style/missing.png"
  validates_attachment :header, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  #validates_with AttachmentSizeValidator, attributes: :profilepic, less_than: 1.megabytes
  validates_with AttachmentPresenceValidator, attributes: :header

 def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
  
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end
   
end
