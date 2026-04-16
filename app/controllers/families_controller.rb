class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_members
  before_action :set_users

 def index
   @family = current_user.family
   if @family
     @members = @family.users
   else
    redirect_to root_path, alert: "You are not a member of family"
   end
 end

 def show
  @member = User.find(params[:id])
  # @members = @family.users
  render layout: false
 end

 def new
   @member = User.new
   render layout: false
 end

 def create
   # @member = User.new(params[:id])
   @member = User.find_by(email:params[:user])
   @family = current_user.family
    if @member
      if @member.update(family: @family)
        redirect_to families_path, notice: "Added #{@member.name} to family"
      else
        redirect_to families_path, alert: "Could not add member"
      end
    else
      # Can not find email "
      flash[:alert] = "User with email #{params[:email]} not found"
      render :new, status: :unprocessable_entity
    end

  def edit
    @member = User.find(params[:id])
    authorize @member
  end

  def update
    @member = User.find(params[:id])
    authorize @member
    if @member.update(user_params)
      redirect_to families_path
    else
      render :edit, status: :unprocessable_entity
    end
  end
 end


 private

  def set_member
    @member = User.find(params[:id])
  end

  def set_family
    @family = current_user.family.users
  end

 def user_params
  params.require(:user).permit(:name, :birthdate, :photo, :role)
 end

end
