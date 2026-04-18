class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_parent

  def update_color
    target = current_user.family.users.find(params[:id])
    if User::AVATAR_COLORS.include?(params[:color])
      target.update!(color: params[:color])
      redirect_to rewards_path, notice: "Color updated for #{target.display_name}."
    else
      redirect_to rewards_path, alert: "Invalid color."
    end
  end

  private

  def require_parent
    return if current_user.parent?

    redirect_to rewards_path, alert: "Only parents can change colors."
  end
end
