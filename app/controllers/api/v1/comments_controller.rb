class Api::V1::CommentsController < ApplicationController
  respond_to :json

  def addcomment
    message = params[:comment]
    uid = params[:uid]
    pid = params[:pid]
    comment = Comment.new({comment_message: message, user_id: uid, post_id: pid})
    user = User.find(params[:uid])
    uname = user.username
    comment.username = uname
    feed = Feed.find(params[:pid])
    feed.comment_count = feed.comment_count + 1
    if comment.save && feed.save
      render json: comment, status: 201
    else
      render json: {errors: "Could not comment"}, status: 422
    end
  end

  def showcomment
    pid = params[:pid]
    comment = Comment.where(post_id: pid).all
    render json: comment, status: 200
  end
end
