class PointAdjustmentsController < ApplicationController
  before_action :authenticate_user!

  def create
    member = current_user.family.users.find(params[:user_id])
    authorize PointAdjustment
    @adjustment = member.point_adjustments.build(point_adjustment_params)

    if @adjustment.save
      redirect_to rewards_path, notice: "Points updated for #{member.display_name}."
    else
      redirect_to rewards_path, alert: @adjustment.errors.full_messages.first
    end
  end

  private

  def point_adjustment_params
    params.permit(:amount, :kind, :reason)
  end
end
