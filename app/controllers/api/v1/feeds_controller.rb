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
#def serialize_feed (feeds = @feeds)
 ##    user_email: feed.user.email
   ## end
#end 
  def nearbyfeeds
    user = User.find(params[:id])
    latstr = user.lat
    longstr = user.lng
    @lat = latstr.to_f
    @long = longstr.to_f
    #location box
    #lowerlat = lat-0.02
    #upperlat = lat+0.02
    #lowerlong = long-0.02
    #upperlong = long+0.02
    #condition
    #user = User.all.where( location!= nil) do |u|
     # if (lowerlat..upperlat).cover?(u.location[0]) && (lowerlong..upperlong).cover?(u.location[1])
      #  @uid = u.id
      #end
      #feed = Feed.where(user_id: uid)
      #render text: ulat
    #end
    #render json: feed, status: 200


    nearbyuser = User.within(1, origin: [@lat,@long]) 

    render json: nearbyuser.as_json(only:[:username,:id] ,include: { feeds: {only:[:message,:like_count,:comment_count]}}), status: 201
  end


  #def report
   # feed = Feed.find(params[:id])
    #feed.report = params[:report]
    #if feed.save
     # render json: feed, status: 200
    #else
     # render json: { errors: "Try again" }, status: 422
    #end
  #end

  private

    def feed_params
      params.require(:feed).permit(:message,:id)
    end



  #def popularity(count, weight: 3)
   # count * weight
  #end

  #SYSTEM_EPOCH   = 1.day.ago.to_i
  #SECOND_DIVISOR = 3600

  #def recentness(timestamp, epoch: SYSTEM_EPOCH, divisor: SECOND_DIVISOR)
   # seconds = timestamp.to_i - epoch
    #(seconds / divisor).to_i
  #end

  #def trending
  #Post = Struct.new(:id, :created_at, :likes_count, :comments_count)
  #posts = [Post.new(1, 1.hour.ago,  1, 1),Post.new(2, 2.days.ago,  7, 1),Post.new(3, 9.hours.ago, 2, 5),Post.new(4, 6.days.ago,  11, 3),Post.new(5, 2.weeks.ago, 58, 92),Post.new(6, 1.week.ago,  12, 7)]
  #sorted = posts.map do |post|
   # pop = popularity(post.likes_count + post.comments_count)
    #rec = recentness(post.created_at, epoch: 1.month.ago.to_i)
    #[pop + rec, post.id]
  #end.sort_by(&:first)
  #sorted.reverse
  #end  
end

