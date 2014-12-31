class Api::V1::UsersController < ApplicationController
  respond_to :json

  def search
    if params[:q]
      @users = User.where("username LIKE ?", "%#{params[:q]}%").limit(10)
    else
      @users = User.all.limit(10)
    end
  end
end
