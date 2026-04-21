class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :set_member, only: [:show, :edit, :update, :destroy]


  def index
    # @family = current_user.family
    if @family.present?
      @members = @family.users.includes(:photo_attachment).order(created_at: :asc)
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
    @member = @family.users.build
    render layout: false
  end

  def create
    @member = User.find_by(email: member_params[:email])

    if @member
      @member.update(member_params.merge(family: @family))
    else
      @member = @family.users.build(member_params)
      @member.password = "123456"
      @member.save
    end

    if @member.persisted?
      respond_to do |format|
        format.turbo_stream
        #format.html { redirect_to family_path(@family), notice: "Added member successfully" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    #@member = @family.users.find(params[:id])
    #authorize @member
    render layout: false
  end

  def update
    @member = User.find(params[:id])
    #authorize @member

    if @member.update(member_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to family_path(@family),
        notice: "Member updated!", status: :see_other }
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    #@member = @family.users.find(params[:id])
    @member.destroy
    respond_to do |format|
      format.turbo_stream
      #format.html { redirect_to family_path(@family),
      #status: :see_other, notice: "Member deleted" }
    end
  end

  private

  def set_family
    @family = current_user.family
  end

  def set_member
    @member = @family.users.find(params[:id])
  end

  def member_params
    params.require(:member).permit(
      :name,
      :email,
      :role,
      :birthdate,
      :photo
    )
  end
end
