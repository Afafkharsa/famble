class RewardTemplatesController < ApplicationController
  before_action :authenticate_user!

  def index
    @reward_templates = RewardTemplate.all
  end

  def new
    @reward_template = RewardTemplate.new
  end

  def create
    @reward_template = RewardTemplate.new(reward_template_params)
    if @reward_template.save
      redirect_to reward_templates_path, notice: "Reward added to library!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reward_template = RewardTemplate.find(params[:id])
    @reward_template.destroy
    redirect_to reward_templates_path, notice: "Reward removed from library."
  end

  private

  def reward_template_params
    params.require(:reward_template).permit(:name, :description, :reward_points, :photo, :icon)
  end
end
