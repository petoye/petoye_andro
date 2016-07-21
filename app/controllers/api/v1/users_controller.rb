class Api::V1::UsersController < ApplicationController
 respond_to :json
 before_action :authenticate_with_token!, only: [:update, :destroy]
 after_action :checkfollowing, only: [:showprofile]

  def new
    user_password = params[:password]
    user_email = params[:email]
    user=User.new({email:  user_email  ,password: user_email, username: "anonymous"})
    if user.save
      render json: user ,status: 200
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
    lat = params[:latitude]
    long = params[:longitude]
    user.location[0] = lat
    user.location[1] = long
    if user.save
      render json: user, status: 200
    else
      render json: {errors: "profile not set"}, status: 422
    end
  end  

  def poststory

    user = User.find(params[:id])
    user.pet_story = params[:story]

    if user.save
      render json: user, status: 200
    else
      render json: {errors: "story not set"}, status: 422
    end
  end

  def showprofile
    user = User.find(params[:hisid])
    already_following = false
    following = params[:hisid]
    follower = params[:myid]
    follow = Follow.where({ follower_id: follower, following_id: following})
    if follow.exists?
      already_following = true
    end
    #render text: already_following
    #render text: :already_following, status: 201
    render json: user.as_json(only:[:username, :owner_type, :pet_breed, :pet_story, :story_like_count]), status: 201
  end

  def checkfollowing

  end

  def likestory

    user = User.find(params[:id])
    user.story_like_count = user.story_like_count + 1
    if user.save
      render json: user, status: 200
    else
      render json: {errors: "couldn't like story"}, status: 422
    end
  end

  def userposts
    uid = params[:id]
    feed = Feed.where(user_id: uid).all
    render json: feed, status: 200
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
        render json: follow, status: 201
      else
        render json: { errors: "could not follow/already following"}, status: 422
      end
    else
      render json: {errors: "already following"}, status: 422
    end
  end

  def discover
    # You will discover users you havent followed within 50 miles of you
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
    render json: user.as_json(only:[:username, :owner_type, :pet_breed, :pet_type]), status: 201
  end
end
