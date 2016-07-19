class Api::V1::FeedsController < ApplicationController
  respond_to :json
#include V1::feeds_serializer
  def create
    id = params[:id]
    msg = params[:message]
    img = params[:image]
    feed = Feed.new({user_id: id, message: msg, like_count: 0, comment_count: 0, image: img})
    if feed.save
      render json: feed, status: 201#, location: [:api_create, feed]
    else
      render json: {errors: "Could not create post"}, status: 422
    end
  end

  def likeit
    feed = Feed.find(params[:pid])
    user = User.find(params[:uid])
    uid = params[:uid]
    pid = params[:pid]
    if feed.likedby.include?(uid) 
      render json: {errors: "already liked"}, status: 422
    else
      feed.likedby[feed.like_count] = uid
      feed.like_count = feed.like_count + 1
      if feed.save
        render json: feed, status:201
      end
    end
  end

  def showlikes
    feed = Feed.find(params[:pid])
    render json: feed.as_json(only:[:likedby] ,include: { user: {only: :email}}), status: 201
    #feed.likedby.each do |f|
      #@a = f.to_i
      #user = User.find(params[:a])
    #end
    #render text: @a
    #json: user, status: 200

  end

  def dislikeit
    feed = Feed.find(params[:post_id])
    feed.like_count = feed.like_count - 1
    if feed.save
      render json: feed, status: 200, location: [:api_dislike, feed]
    else
      render json: {errors: "Could not be disliked"}, status: 422
    end
  end


  def report
    feed = Feed.find(params[:pid])
    repstr = params[:report]
    rep = repstr.to_i
    count = feed.report.count
    feed.report[count] = rep
    if feed.save
      render json: feed.as_json(only:[:id,:report]), status: 201
    else
      render json: { errors: "could not report" }, status:422
    end
    if feed.report.count > 200
      feed.destroy
      head 204
    end
  end


  def index
    feeds = Feed.all  
    render json: feeds.as_json(only:[:message] ,include: { user: {only: :email}}), status: 201
  end


  def nearbyfeeds
    user = User.find(params[:id])
    latstr = user.lat
    longstr = user.lng
    @lat = latstr.to_f
    @long = longstr.to_f
    nearbyuser = User.within(1, origin: [@lat,@long]) 
    render json: nearbyuser.as_json(only:[:username,:id] ,include: { feeds: {only:[:message,:like_count,:comment_count]}}), status: 201
  end


  def followeduserfeeds
    r_id = []
    u_id = params[:id]
    Follow.where(follower_id: u_id).each do |u|
    r_id << u.following_id.to_i
    end 
    if r_id.count > 0
      feed = Feed.where(user_id: [r_id])
      render json: feed.as_json(only:[:user_id,:message,:like_count,:comment_count]), status: 201
    else
      render json: { errors: "No followed users" }, status: 422
    end
  end



  private

    def feed_params
      params.require(:feed).permit(:message,:id)
    end

end

