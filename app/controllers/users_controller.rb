class UsersController < ApplicationController
  before_action :get_user

  def followers
    render json: @current_user.followers
  end

  def following
    render json: @current_user.following
  end

  def clock_in
    @current_user.clock_ins.create(clock_in_time: Time.current)

    render json: { message: "Clock-in success"}, status: :ok
  end

  def clock_out
    msg = "Clock-out success"
    status = 'ok'

    clock_in = @current_user.clock_ins.find_by(id: params[:clock_in_id])
    if clock_in.present?
      clock_out_time = params[:clock_out_time].present? ? params[:clock_out_time] : Time.current
      clock_in.update(clock_out_time: clock_out_time)
    else
      msg = "Clock-in Not found"
      status = "unprocessable_entity"
    end

    render json: { message: msg}, status: status.to_sym
  end

  def get_user
    @current_user = User.find_by(id: params[:id])
    render json: { error: "User Not Found" }, status: :unauthorized if @current_user.blank?
  end
end
