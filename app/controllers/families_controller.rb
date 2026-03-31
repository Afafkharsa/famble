class FamiliesController < ApplicationController
 # before_action :authenticate_user!
 def index
   @family = current_user.family
   if @family
     @members = @family.users
   else
    redirect_to root_path, alert: "You are not a member of family"
   end
 end

 def show
  @family = Family.find(params[:id])
  @members = @family.users
 end

 def add_member
   @family = Family.find(params[:id])
   @user = User.find_by(email:params[:email])
    if @user
     @user.update(family:@family)
     redirect_to family_path(@family), notice: "Added #{user.first_name} to family"
    else
      redirect_to family_path(@family), alert: "Not found #{user.first_name} "
    end
 end


 private

 def family_params
  params.require(:family).permit(:name)
 end

end
