class Api::V1::CommentsController < ApplicationController
  respond_to :json

  def addcomment
    message = params[:comment]
    uid = params[:uid]
    pid = params[:pid]
    comment = Comment.new({comment_message: message, user_id: uid, post_id: pid})
    feed = Feed.find(params[:pid])
    feed.comment_count = feed.comment_count + 1
    if comment.save && feed.save
      render json: comment.as_json(only:[:id,:comment_message]), status: 201
    else
      render json: {errors: "Could not comment"}, status: 422
    end
  end

  def showcomment
    pid = params[:pid]
    comment = Comment.where(post_id: pid).all
    if comment.exists?
      render json: comment.as_json(only:[:comment_message] ,include: { user: {only: :username}}), status: 200
    else
      render json: {errors: "No comments yet"}, status: 422
    end
  end
end