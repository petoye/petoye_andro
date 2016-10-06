 class Api::V1::FeedsController < ApplicationController
  respond_to :json

  def create
    id = params[:uid]
    msg = params[:message]
    img = params[:image]
    feed = Feed.new({user_id: id, message: msg, like_count: 0, comment_count: 0, image: img})
    feed.save
    feed.imageurl = feed.image.url(:original)
    feed.smallimageurl = feed.image.url(:thumb)
    if feed.save
      render json: feed.as_json(only:[:id]), status:201
    else
      render json: {errors: "Could not create post"}, status: 422
    end
  end

  def likeit
    feed = Feed.find(params[:pid])
    uid = params[:uid]
    pid = params[:pid]
    #notif
    user = User.find(uid)
    uname = user.username
    prof = user.imageurl
    postpic = feed.smallimageurl
    @notif = "#{uname}[#{uid}][#{prof}] liked your post[#{pid}][#{postpic}]"
    token = user.token
    #end notif

    #push notif
    pusher = Grocer.pusher(
      certificate: "#{Rails.root}/public/certificate.pem",      # required
      passphrase:  "",                       # optional
      gateway:     "gateway.push.apple.com", # optional; See note below.
      port:        2195,                     # optional
      retries:     3                         # optional
    ) 


    notification = Grocer::Notification.new(
      device_token: token,
      alert: "#{uname} liked your post",
      sound: 'default',
      badge:  0
    )

    pusher.push(notification) # return value is the number of bytes sent successfully

    if feed.likedby.include?(uid) 
      render json: {errors: "already liked"}, status: 422
    else
      feed.likedby[feed.like_count] = uid
      feed.like_count = feed.like_count + 1
      #notif
      x_id = feed.user_id
      userx = User.find(x_id)
      userx.notify << @notif
      #end notif
      if feed.save && userx.save
        render json: feed.as_json(only:[:likedby,:like_count]), status: 200
      else
        render json: { errors: "Could not be liked"}, status:422
      end
    end
    #render json: x_id
  end

  def showlikes
    l_id = []
    feed = Feed.find(params[:pid])
    l_id << feed.likedby
    if feed.likedby.count > 0
      user = User.find([l_id])
      render json: user.as_json(only:[:username,:id,:imageurl]), status: 200
    else
      render json: { errors: "No likes yet" }, status: 422
    end
  end

  def dislikeit
    feed = Feed.find(params[:pid])
    uid = params[:uid]
    if feed.likedby.include?(uid)
      feed.likedby.delete(uid)
      feed.like_count = feed.like_count - 1
      if feed.save
        render json: feed.as_json(only:[:likedby,:like_count]), status: 200
      else
        render json: {errors: "Could not be disliked"}, status: 422
      end
    else
      render json: {errors: "Not liked so can't be disliked"}, status:422 
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
    uid = params[:uid]
    user = User.find(params[:uid])
    latstr = user.lat
    longstr = user.lng
    @lat = latstr.to_f
    @long = longstr.to_f
    nearbyuser = User.where.not(id: uid).within(10, origin: [@lat,@long]) 

    if nearbyuser.exists?
      render json: nearbyuser.as_json(only:[:username,:id,:imageurl] ,include: { feeds: {only:[:id,:message,:like_count,:comment_count,:imageurl,:created_at]}}), status: 201
    else
      render json: { errors: "No nearby posts" }, status: 422
    end
  end


  def followeduserfeeds
    r_id = []
    u_id = params[:uid]
    Follow.where(follower_id: u_id).each do |u|
    r_id << u.following_id.to_i
    end 
    if r_id.count > 0
      feed = Feed.where(user_id: [r_id])
      render json: feed.as_json(only:[:id,:message,:like_count,:comment_count,:imageurl,:created_at], include: { user: {only: [:username,:id,:imageurl]}}), status: 200
    else
      render json: { errors: "No followed users" }, status: 422
    end
  end

  def onefeed
    feed = Feed.find(params[:pid])
    render json: feed.as_json(only:[:id,:message,:like_count,:comment_count,:imageurl,:created_at], include: { user: {only: [:username,:id,:imageurl]}}), status: 200
  end

  def timeelapsed
    feed = Feed.find(params[:id])
    t1 = feed.created_at
    t2 = Time.now
    t3 = (t2 - t1).to_i

    if t3 < 60
      if t3 == 1
        time = "#{t3} second ago"
      else
        time = "#{t3} seconds ago"
      end
        elsif t3 >= 60 && t3 < 3600
          t4 = (t3/60).to_i
          if t4 == 1
            time = "#{t4} minute ago"
          else
            time = "#{t4} minutes ago"
          end
            elsif t3 >= 3600 && t3 < 86400
              t4 = (t3/3600).to_i
              if t4 == 1
                time = "#{t4} hour ago"
              else
                time = "#{t4} hours ago"
              end
                elsif t3 >= 86400 && t3 < 604800
                  t4 = (t3/86400).to_i
                  if t4 == 1
                    time = "#{t4} day ago"
                  else
                    time = "#{t4} days ago"
                  end
                    elsif t3 >= 604800
                      t4 = (t3/604800).to_i
                      if t4 == 1
                        time = "#{t4} week ago"
                      else
                        time = "#{t4} weeks ago"
                      end
    end

    render json: time, status:200
  end



  private

    def feed_params
      params.require(:feed).permit(:message,:id)
    end

end

