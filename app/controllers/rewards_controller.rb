class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @family = current_user.family
    @rewards = Reward.where(user: @family.users)
  end

  def new
    @reward = Reward.new
    @family_members = current_user.family.users
  end

  def create
    @reward = Reward.new(reward_params)
    @reward.user = User.find(params[:reward][:user_id])
    if @reward.save
      redirect_to rewards_path, notice: "Reward created successfully!"
    else
      @family_members = current_user.family.users
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    redirect_to rewards_path, notice: "Reward deleted."
  end

  def redeem
    @reward = Reward.find(params[:id])
    @reward.update(redeemed: true, redeemed_at: Time.current)
    redirect_to rewards_path, notice: "#{@reward.name} redeemed!"
  end

  def edit
    @reward = Reward.find(params[:id])
    @family_members = current_user.family.users
  end

  def update
    @reward = Reward.find(params[:id])
    if @reward.update(reward_params)
      redirect_to rewards_path, notice: "Reward updated!"
    else
      @family_members = current_user.family.users
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def reward_params
    params.require(:reward).permit(:name, :description, :reward_points, :user_id)
  end
end
