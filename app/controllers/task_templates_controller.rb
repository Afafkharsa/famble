class TaskTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task_template, only: [:edit, :update, :destroy]
  before_action :require_family_owned, only: [:edit, :update, :destroy]

  def index
    @role = current_user.role
    @generic_templates = TaskTemplate.where(family_id: nil)
    @family_templates = current_user.family.task_templates
  end

  def new
    @task_template = TaskTemplate.new
  end

  def create
    @task_template = current_user.family.task_templates.new(task_template_params)
    if @task_template.save
      redirect_to task_templates_path, notice: "Template added to library!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task_template.update(task_template_params)
      redirect_to task_templates_path, notice: "Template updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task_template.destroy
    redirect_to task_templates_path, status: :see_other, notice: "Template removed."
  end

  private

  def set_task_template
    @task_template = TaskTemplate.find(params[:id])
  end

  def require_family_owned
    return if @task_template.family_id.present?

    redirect_to task_templates_path, alert: "Generic templates can't be modified."
  end

  def task_template_params
    params.require(:task_template).permit(:name, :description, :task_points, :montly_frequency, days: [])
  end
end
