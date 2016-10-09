class Api::V1::CommentsController < ApplicationController
  respond_to :json

  def addcomment
    feed = Feed.find(params[:pid])

    message = params[:comment]
    uid = params[:uid]
    pid = params[:pid]

    #notif
    user = User.find(uid)
    uname = user.username
    prof = user.imageurl
    postpic = feed.smallimageurl
    @notif = "#{uname}[#{uid}][#{prof}] commented on your post[#{pid}][#{postpic}]"
    #end notif

    token = feed.user.token

    pusher = Grocer.pusher(
      certificate: "#{Rails.root}/public/certificate.pem",      # required
      passphrase:  "1234",                       # optional
      gateway:     "gateway.sandbox.push.apple.com", # optional; See note below.
      port:        2195,                     # optional
      retries:     3                         # optional
    ) 


    notification = Grocer::Notification.new(
      device_token: "#{token}",
      alert: "#{uname} commented on your post: #{message}",
      badge:  1
    )

    pusher.push(notification)

    comment = Comment.new({comment_message: message, user_id: uid, post_id: pid})
    
    feed.comment_count = feed.comment_count + 1

    #notif
    x_id = feed.user_id
    userx = User.find(x_id)
    userx.notify << @notif
    #end notif
    if comment.save && feed.save && userx.save
      render json: comment.as_json(only:[:id,:comment_message]), status: 201
    else
      render json: {errors: "Could not comment"}, status: 422
    end
  end

  def showcomment
    pid = params[:pid]
    comment = Comment.where(post_id: pid).all
    if comment.exists?
      render json: comment.as_json(only:[:comment_message] ,include: { user: {only: [:username,:id,:imageurl]}}), status: 200
    else
      render json: {errors: "No comments yet"}, status: 422
    end
  end
end