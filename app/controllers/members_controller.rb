class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :set_member, only: [:show, :edit, :update, :destroy]


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
      #format.html { redirect_to family_path(@family), notice: "Added member successfully" }
      format.turbo_stream
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
        #format.html { redirect_to family_path(@family),
        #status: :see_other, notice: "Member Updated" }
        format.turbo_stream
      end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    #@member = @family.users.find(params[:id])
    @member.destroy
    respond_to do |format|
      #format.html { redirect_to family_path(@family),
      #status: :see_other, notice: "Member deleted" }
      format.turbo_stream #Use for delete without non-reload the page
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
    params.require(:user).permit(
      :name,
      :email,
      :relationship,
      :birthday,
      :photo
    )
  end
end
