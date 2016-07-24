class Api::V1::ConversationsController < ApplicationController
  respond_to :json

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    #render json: { conversation_id: @conversation.id }
    mssg = params[:body]
    c_id = @conversation.id
    u_id = params[:sender_id]
    message = Message.new({ body: mssg, conversation_id: c_id , user_id: u_id})

    if message.save
      render json: message.as_json(only:[:body,:conversation_id] ,include: { user: {only: :username}}), status: 201
    else
      render json: {errors: "Can't send message"}, status: 422
    end
  end

  def open
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
      c_id = @conversation.id
      message = Message.where(conversation_id: c_id).all
      render json: message.as_json(only:[:body,:user_id] ,include: { user: {only: :username}}), status: 201
    else
      render json: {errors: "No messages"}, status: 422
    end
  end

  def all
    r_id = []
    c_id = []
    u_id = params[:id]
    #Conversation.where(["sender_id = ? OR recipient_id = ?", u_id, u_id]).each do |u|
      #if u_id == u.recipient_id
       # r_id << u.sender_id
      #elsif u_id == u.sender_id
       # r_id << u.recipient_id
      #end
      #r_id << u.sender_id
    #end 

    Conversation.where(sender_id: u_id).each do |u|
      r_id << u.recipient_id
      c_id << u.id
      Conversation.where(recipient_id: u_id).each do |x|
        r_id << x.sender_id
        c_id << x.id
      end
    end

    if r_id.count > 0
      user = User.find([r_id])
      render json: user.as_json(only:[:username,:id]), status: 201
    else
      render json: {errors: "No conversations"}, status: 422
    end
    #render json: c_id
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end
