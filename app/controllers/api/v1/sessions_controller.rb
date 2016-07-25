class Api::V1::SessionsController < ApplicationController
  def new
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user and user.valid_password?(user_password)
      #sign_in user
      user.generate_authentication_token!
      user.save
      render json: user.as_json(only:[:id]), status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password"}, status: 422
    end
    #render json: user
  end
  #def create     
   # if params[:session][:email].blank? || params[:session][:password].blank?       
    #  render_error_blank_fields     
    #elsif user = User.find_by_email(params[:session][:email])       
      #binding.pry       
     # if user.valid_password?(params[:session][:password])         
       # render json: user       
      #else         
        #render_error_bad_password       
      #end     
    #else       
     # render_error_no_account     
    #end   
  #end     

  #private   
  #def render_error_blank_fields      
   # render json: { errors: ["Please fill the fields email & password"] }   
  #end 

  #def render_error_no_account     
   # render json: { errors: ["There is no account associated to this email"] }   
  #end 

  #def render_error_bad_password     
   # render json: {errors: ["The password you provided is incorrect"]}   
  #end 

end
