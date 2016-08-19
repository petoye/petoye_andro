class Api::V1::UsersController < ApplicationController
 respond_to :json
 before_action :authenticate_with_token!, only: [:update, :destroy]

  def new
    user_password = params[:password]
    user_email = params[:email]
    user=User.new({email: user_email,password: user_password, username: "anonymous"})
    if user.save
      render json: user.as_json(only:[:id]), status: 201
    else
      render json: {errors: "could not be created"}, status: 422
    end
  end

  def fbnew
    user_email = params[:email]
    user_password = params[:password]
    u = params[:username]
    user_name = u.downcase

    lat1 = params[:lat]
    lng1 = params[:lng]

    o_t = params[:otype]
    o_type=o_t.downcase
    p_t = params[:ptype]
    p_type = p_t.downcase
    b = params[:breed]
    breed = b.downcase

    p_url = params[:url]

    user=User.new({email: user_email,password: user_password, username: user_name, owner_type: o_type, pet_type: p_type, pet_breed: breed, lat: lat1, lng: lng1, imageurl: p_url})

    if user.save
      render json: user.as_json(only:[:id,:username]), status: 200
    else
      render json: {errors: "profile not set"}, status: 422
    end
  end

  def info
    user=User.find(params[:id])
    o_t = params[:otype]
    user.owner_type=o_t.downcase
    u = params[:username]
    user.username = u.downcase
    p_t = params[:ptype]
    user.pet_type = p_t.downcase
    b = params[:breed]
    user.pet_breed = b.downcase
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

    #notif got who's following you
    user = User.find(follower)
    uname = user.username
    @notif = "#{uname}[#{follower}] followed you"
    #end notif

    follow = Follow.where({ follower_id: follower, following_id: following})
    if follow.exists?
      already_following = true
    end

    if already_following == false
      follow = Follow.new({ follower_id: follower, following_id: following })
      #notif
        userx = User.find(following)
        userx.notifications << @notif
      #end notif
      if follow.save && userx.save
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
    render json: user.as_json(only:[:id, :username, :owner_type, :pet_breed, :pet_type]), status: 200
  end


  def search
    query = params[:query]
    name = query.downcase
    parameter = params[:parameter]
    if parameter == 'user'
      @x = 'username'
    elsif parameter == 'type'
      @x = 'pet_type'
    elsif parameter == 'breed'
      @x = 'pet_breed'
    end

    user = User.where("#{@x} LIKE ?","#{name}%")
    render json: user.as_json(only:[:username, :owner_type, :pet_breed, :pet_type]), status: 302
    #render json: name
  end

  def notification
    user = User.find(params[:id])
    render json: user.as_json(only:[:notifications]), status: 200
  end

end
