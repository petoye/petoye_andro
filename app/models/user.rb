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
 serialize :location, Array
 validates_length_of :pet_story, maximum: 300
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
