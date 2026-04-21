class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @family = current_user.family
    @rewards = Reward.where(user: @family.users)
  end

  def new
    @reward = Reward.new
    @family_members = current_user.family.users
    @reward_templates = RewardTemplate.all
  end

  def create
    @reward = Reward.new(reward_params)
    @reward.user = User.find(params[:reward][:user_id])

    if @reward.reward_template.present? && !@reward.photo.attached? && @reward.reward_template.photo.attached?
      @reward.photo.attach(@reward.reward_template.photo.blob)
    end

    if @reward.save
      redirect_to rewards_path, notice: "Reward created successfully!"
    else
      @family_members = current_user.family.users
      @reward_templates = RewardTemplate.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reward = Reward.find(params[:id])
    authorize @reward
    @reward.destroy
    redirect_to rewards_path, notice: "Reward deleted."
  end

  def redeem
    @reward = Reward.find(params[:id])
    user = @reward.user

    if user.available_points >= @reward.reward_points
      @reward.update(redeemed: true, redeemed_at: Time.current)
      redirect_to rewards_path, notice: "#{@reward.name} redeemed!"
    else
      redirect_to rewards_path, alert: "Not enough points! #{user.name || user.email} has #{user.available_points} pts but needs #{@reward.reward_points} pts."
    end
  end

  def edit
    @reward = Reward.find(params[:id])
    authorize @reward
    @family_members = current_user.family.users
  end

  def update
    @reward = Reward.find(params[:id])
    authorize @reward
    if @reward.update(reward_params)
      redirect_to rewards_path, notice: "Reward updated!"
    else
      @family_members = current_user.family.users
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def reward_params
    params.require(:reward).permit(:name, :description, :reward_points, :user_id, :photo, :reward_template_id, :icon)
  end
end
