class Api::V1::UsersController < ApplicationController
 respond_to :json
 before_action :authenticate_with_token!, only: [:update, :destroy]
 after_action :checkfollowing, only: [:showprofile]

  #def show
   # respond_with User.find(params[:id])
  #end

  #def update
 #
  #  if user.update(user_params)
   #   render json: user, status: 200, location: [:api, user]
    #else
     # render json: { errors: user.errors }, status: 422
    #end
  #end

  #def destroy
   # current_user.destroy
    #head 204
  #end

  def new
    user_password = params[:password]
    user_email = params[:email]
    user=User.new({email:  user_email  ,password: user_email, username: "anonymous"})
    #user.create({email:  user_email  ,password: user_email})
    if user.save
      render json: user ,status: 200
    else
      render json: {errors: "could not be created"}, status: 422
    end
  end

  def info
    #info_pet_type=params[:pet_type]
    #info_pet_breed=params[:pet_breed]
    user=User.find(params[:id])
    user.owner_type=params[:otype]
    #username, pet_type, pet_breed 
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
    #pet story

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
    #Follow.where(follower_id: follower).all.each do |f|
     # if f.following_id.include?(following)
      #  already_following = already_following + 1
      #end
    #end
    #render text: already_following
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

  #def location
   # user = User.find(params[:id])
    #lat = params[:location][:lattitude]
    #long = params[:location][:longitude]
    #user.location = {lat,long}
    #if user.save
     # render json: user, status: 200
    #else
     # render json: {errors: "Didn't update location"}, status: 422
    #end
  #end
end
