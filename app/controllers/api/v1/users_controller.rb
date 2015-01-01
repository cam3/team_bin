class Api::V1::UsersController < ApplicationController
  respond_to :json

  def search
    query = params[:q] || params[:term] || nil
    if query
      @users = User.where("username LIKE ?", "%#{query}%").limit(10)
    else
      @users = User.all.limit(10)
    end

    @users = @users.to_a.map { |x| x.username }
  end
end
