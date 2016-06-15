require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1+json" }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end
  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] =  @user.auth_token
    end
  end
  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
       request.headers['Authorization']= @user.auth_token #we added this line
      delete :destroy, id: @user.auth_token
    end

    it { should respond_with 204 }

  end
  
end
