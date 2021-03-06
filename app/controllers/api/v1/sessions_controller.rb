class Api::V1::SessionsController < ApplicationController
  def new
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user and user.valid_password?(user_password)
      user.generate_authentication_token!
      user.save
      render json: user.as_json(only:[:id]), status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password"}, status: 422
    end
  end
end
