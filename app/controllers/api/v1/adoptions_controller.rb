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
      render json: adoption, status: 201
    else
      render json: {errors: "could not create adoption"}, status: 422
    end
  end

  def show
    adoptions = Adoption.all
    render json: adoptions, status: 200
  end


end
