class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  # before_action :set_users

  def index
    # @family = current_user.family
    if @family.present?
      @members = @family.users.includes(:photo_attachment)
    else
      redirect_to root_path, alert: "You are not a member of a family"
    end
  end

  def show
    # @family = current_user.family
    @member = @family.users.find(params[:id])
    render layout: false
  end

  def new
    # @family = current_user.family
    @member = User.new
    render layout: false
  end

  def create
    @member = User.find_by(email: params[:member][:email])
    @family = current_user.family

    if @member
      # กรณีมี User ในระบบอยู่แล้ว แต่อยากดึงเข้าครอบครัว
      @member.update(user_params.merge(family: @family))
    else
      # กรณีสร้าง User ใหม่ (ตามภาพที่ 1 ของคุณ)
      @member = User.new(user_params) # ข้อมูล name, birthday จะถูกดึงจากตรงนี้
      @member.family = @family
      @member.password = "123456" # หรือรหัสผ่านเริ่มต้น
      @member.save
    end

    if @member.persisted?
      redirect_to families_path, notice: "Added member successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @member = @family.users.find(params[:id])
    authorize @member
    render layout: false
  end

  def update
    @member = User.find(params[:id])
    authorize @member
    if @member.update(user_params)
      redirect_to families_path, notice: "Member updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member = @family.users.find(params[:id])
    @member.destroy
    redirect_to families_path, status: :see_other
  end



 private

  def set_member
    @member = User.find(params[:id])
  end

  def set_family
    @family = current_user.family
  end

 def member_params
    params.require(:user).permit(:email, :name, :birthdate, :role, :photo)
 end
end
