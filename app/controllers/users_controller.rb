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
    @clock_ins = @current_user.clock_ins.order(:created_at)

    render json: { data: @clock_ins, message: "Clock-in success"}, status: :ok
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

  def sleep_records
    sql = "select c.clock_in_time, c.clock_out_time, EXTRACT(HOUR FROM (c.clock_out_time - c.clock_in_time)) as duration FROM clock_ins c join users u on u.id = c.user_id where c.user_id = #{@current_user.id} order by duration ASC"
    @sleep_records = ActiveRecord::Base.connection.execute(sql)
    
    render json: @sleep_records, status: :ok
  end

  def following_sleep_records
    following_ids = @current_user.following.pluck(:id).join(",")
    sql = "select u.name, c.clock_in_time, c.clock_out_time, EXTRACT(HOUR FROM (c.clock_out_time - c.clock_in_time)) as duration FROM clock_ins c join users u on u.id = c.user_id where c.user_id in (#{following_ids}) order by duration ASC"
    @sleep_records = ActiveRecord::Base.connection.execute(sql)
    
    render json: @sleep_records, status: :ok
  end

  def get_user
    @current_user = User.find_by(id: params[:id])
    render json: { error: "User Not Found" }, status: :unauthorized if @current_user.blank?
  end
end
