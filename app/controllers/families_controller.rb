class FamiliesController < ApplicationController
  before_action :authenticate_user!
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
   @member = User.new(params[:id])
   @user = User.find_by(email:params[:email])
    if @user
     @user.update(family:@family)
     redirect_to family_path(@family), notice: "Added #{user.first_name} to family"
    else
      redirect_to family_path(@family), alert: "Not found #{user.first_name} "
    end
 end


 private

 def user_params
  params.require(:user).permit(:name, :birthdate, :photo, :role)
 end

end
