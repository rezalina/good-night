class RelationshipsController < ApplicationController
  before_action :search_users
  
  def follow
    msg = 'Successfully follow user'
    status = 'ok'

    if @current_user.present? || @followed_user.present?
      if @current_user.following.where(id: @followed_user.id).present?
        msg = 'Already following this user'
        status = 'unprocessable_entity'
      else
        @current_user.follow(@followed_user)
      end
    else
      msg = 'User not Found'
      status = 'unprocessable_entity'
    end

    render json: { message: msg}, status: status.to_sym
  end

  def unfollow
    msg = 'Successfully unfollow user'
    status = 'ok'

    if @current_user.present? || @followed_user.present?
      @current_user.unfollow(@followed_user)
    else
      msg = 'User not Found'
      status = 'unprocessable_entity'
    end

    render json: { message: msg}, status: status.to_sym
  end

  def search_users
    @current_user = User.find_by(id: params[:id])
    @followed_user = User.find_by(id: params[:followed_id])
  end
end
