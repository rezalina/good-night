class UsersController < ApplicationController
  before_action :get_user

  def followers
    render json: @current_user.followers
  end

  def following
    render json: @current_user.following
  end

  def get_user
    @current_user = User.find_by(id: params[:id])
    render json: { error: "User Not Found" }, status: :unauthorized if @current_user.blank?
  end
end
