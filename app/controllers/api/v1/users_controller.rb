class Api::V1::UsersController < ApplicationController
 respond_to :json
 before_action :authenticate_with_token!, only: [:update, :destroy]
 after_action :checkfollowing, only: [:showprofile]

  def new
    user_password = params[:password]
    user_email = params[:email]
    user=User.new({email:  user_email  ,password: user_email, username: "anonymous"})
    if user.save
      render json: user.as_json(only:[:id]), status: 201
    else
      render json: {errors: "could not be created"}, status: 422
    end
  end

  def info
    user=User.find(params[:id])
    user.owner_type=params[:otype]
    user.username = params[:username]
    user.pet_type = params[:ptype]
    user.pet_breed = params[:breed]
    lat = params[:lat]
    lng = params[:lng]
    user.lat = lat
    user.lng = lng
    if user.save
      render json: user.as_json(only:[:id,:username]), status: 200
    else
      render json: {errors: "profile not set"}, status: 422
    end
  end  

  def poststory

    user = User.find(params[:id])
    user.pet_story = params[:story]

    if user.save
      render json: user.as_json(only:[:pet_story, :story_like_count]), status: 200
    else
      render json: {errors: "story not set"}, status: 422
    end
  end

  def showprofile
    user = User.find(params[:id])
    if user.save
      render json: user.as_json(only:[:id,:username, :owner_type, :pet_breed, :pet_story, :story_like_count]), status: 200
    else
      render json: {errors: "can't show profile" }, status: 422
    end
  end

  def checkfollowing
    already_following = false
    follower = params[:myid]
    following = params[:hisid]
    follow = Follow.where({ follower_id: follower, following_id: following})
    if follow.exists?
      already_following = true
    end
    render json: already_following, status: 200
  end

  def likestory
    user = User.find(params[:id])
    user.story_like_count = user.story_like_count + 1
    if user.save
      render json: user.as_json(only:[:story_like_count]), status: 200
    else
      render json: {errors: "couldn't like story"}, status: 422
    end
  end

  def userposts
    uid = params[:id]
    feed = Feed.where(user_id: uid).all
    if feed.exists?
      render json: feed.as_json(only:[:message,:like_count,:comment_count], include: { user: {only: :username}}), status: 200
    else
      render json: { errors: "no posts" }, status: 422
    end
  end

  def follow
    follower = params[:myid]
    following = params[:hisid]
    already_following = false

    follow = Follow.where({ follower_id: follower, following_id: following})
    if follow.exists?
      already_following = true
    end

    if already_following == false
      follow = Follow.new({ follower_id: follower, following_id: following })
      if follow.save
        render json: follow.as_json(only:[:id,:follower_id,:following_id]), status: 201
      else
        render json: { errors: "could not follow"}, status: 422
      end
    else
      render json: {errors: "already following"}, status: 422
    end
  end

  def discover
    # Discover users you havent followed within 50 miles of you
    f_id = []
    x_id = []
    d_id = []
    u_id = params[:id].to_i
    user = User.find(params[:id])
    latstr = user.lat
    longstr = user.lng
    @lat = latstr.to_f
    @long = longstr.to_f

    Follow.where(follower_id: u_id).each do |u|
    f_id << u.following_id.to_i
    end 

    f_id << u_id

    User.all.each do |p|
    x_id << p.id
    end

    d_id = x_id - f_id

    user = User.where(id: [d_id]).within(50, origin: [@lat,@long])
    render json: user.as_json(only:[:username, :owner_type, :pet_breed, :pet_type]), status: 200
  end


  def search
    name = params[:query]
    parameter = params[:parameter]
    if parameter == 'user'
      @x = 'username'
    elsif parameter == 'type'
      @x = 'pet_type'
    elsif parameter == 'breed'
      @x = 'pet_breed'
    end

    user = User.where("#{@x} LIKE ?","%#{name}%")
    render json: user.as_json(only:[:username, :owner_type, :pet_breed, :pet_type]), status: 302
  end

end
