class Api::V1::AdoptionsController < ApplicationController
  respond_to :json

  def newadoption
    uid = params[:id]
    typ = params[:type]
    br = params[:breed]
    ag = params[:age]
    des = params[:description]
    img = params[:image]
    adoption = Adoption.new({user_id: uid, pet_type: typ, breed: br, age: ag, description: des, image: img})

    if adoption.save
      render json: adoption.as_json(only:[:id]), status: 201
    else
      render json: {errors: "could not create adoption"}, status: 422
    end
  end

  def show
    adoption = Adoption.all
    if adoption
      render json: adoption.as_json(only:[:pet_type,:breed,:age,:description], include: { user: {only: :username}}), status: 200
    else
      render json: { errors: "No adoptions"}, status: 422
    end
  end
end
