class PointAdjustmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_parent

  def create
    target = current_user.family.users.find(params[:point_adjustment][:user_id])
    adjustment = target.point_adjustments.new(adjustment_params.merge(created_by: current_user))

    if adjustment.save
      redirect_to rewards_path, notice: adjustment.label
    else
      redirect_to rewards_path, alert: adjustment.errors.full_messages.to_sentence
    end
  end

  def reset
    target = current_user.family.users.find(params[:user_id])
    target.update!(points_reset_at: Time.current)
    redirect_to rewards_path, notice: "Points reset for #{target.name}"
  end

  private

  def adjustment_params
    params.require(:point_adjustment).permit(:amount, :reason)
  end

  def require_parent
    return if current_user.parent?

    redirect_to rewards_path, alert: "Only parents can adjust points."
  end
end
