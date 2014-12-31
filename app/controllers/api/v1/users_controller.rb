class Api::V1::UsersController < ApplicationController
  respond_to :json

  def search
    @users = User.where("username LIKE ?", "%#{params[:q]}%")

    respond_with @users
  end
end
