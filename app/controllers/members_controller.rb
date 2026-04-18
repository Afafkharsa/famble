class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /families/:family_id/members
  def index
    # @family = current_user.family
    if @family.present?
      @members = @family.users.includes(:photo_attachment)
    else
      redirect_to root_path, alert: "You are not a member of a family"
    end
  end

  # GET /families/:family_id/members/:id
  def show
    # @family = current_user.family
    @member = @family.users.find(params[:id])
    render layout: false
  end

  # GET /families/:family_id/members/new
  def new
    @member = @family.users.build
    render layout: false
  end

  # POST /families/:family_id/members
  def create
    @member = User.find_by(email: user_params[:email])

    if @member
      @member.update(user_params.merge(family: @family))
    else
      @member = @family.users.build(user_params)
      @member.password = "123456"
      @member.save
    end

    if @member.persisted?
      redirect_to family_path(@family), notice: "Added member successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /families/:family_id/members/:id/edit
  def edit
    #@member = @family.users.find(params[:id])
    authorize @member
    render layout: false
  end

  # PATCH/PUT /families/:family_id/members/:id
  def update
    authorize @member

    if @member.update(user_params)
      redirect_to family_path(@family), notice: "Member updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /families/:family_id/members/:id
  def destroy
    #@member = @family.users.find(params[:id])
    @member.destroy
  redirect_to family_path(@family), notice: "Member deleted"
  end

  private

  def set_family
    @family = current_user.family
  end

  def set_member
    @member = @family.users.find(params[:id])
  end

  def member_params
    params.require(:user).permit(
      :name, :email, :relationship, :birthday, :photo
    )
  end
end
