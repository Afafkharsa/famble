class TaskTemplatesController < ApplicationController
  before_action :set_task_template, only: [:show, :edit, :update, :destroy]
  before_action :set_family, only: [:index, :show, :update, :destroy]

  def index
    @role = current_user.role
    @generic_templates = TaskTemplate.all.where("family_id IS NULL")
    @family_templates = current_user.family.task_templates
  end

  def show
  end

  def new
    @task_template = TaskTemplate.new()
  end

  def create
    @task_template = TaskTemplate.new(task_template_params)
    if @task_template.save
      redirect_to task_template_path(@task_template)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @family = @task_template.family
      @task_template.update(task_template_params)
    end
    redirect_to task_template_path(@task_template)
  end

  def destroy
    if @family = @task_template.family
      @task_template.destroy
    end
    redirect_to task_templates_path, status: :see_other
  end

  private

  def set_task_template
    @task_template = TaskTemplate.find(params[:id])
  end

  def set_family
     @family = current_user.family
  end

  def task_template_params
    params.require(:task_template).permit(
      :name,
      :description,
      :montly_frequency,
      :task_points,
      days: []
    )
  end

end
