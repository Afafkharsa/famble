class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit]

  def index
    @tasks = policy_scope(Task)
    @user = current_user
    @user_tasks = @tasks.where(user: @user)
    @family_tasks = @tasks.where.not(user: @user)
  end

  def show
    authorize @task
  end

  def new
    @task= Task.new({
      user_id: params[:user],
      name: params[:name],
      description: params[:description],
      task_points: params[:task_points],
      days: params[:days],
      task_template: params[:task_template]
    })
    @task_templates = TaskTemplate.all
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    authorize @task

    if @task.save
      redirect_to tasks_path, notice: "Task created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
    @task_templates = TaskTemplate.all
  end

  def update
    authorize @task

    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: "Task updated." }
        format.json { render json: @task, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @task
    @task.destroy
    redirect_to tasks_path, status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_users
    @users = current_user.family.users
  end

  def task_params
    params.require(:task).permit(
      :user_id,
      :name,
      :description,
      :status,
      :start_date,
      :end_date,
      :task_points,
      :days,
      :montly_frequency,
      :task_template,
      :validation
    )
  end
end
