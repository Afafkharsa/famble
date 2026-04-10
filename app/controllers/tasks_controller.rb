class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit]

  def index
    @user = current_user
    @user_tasks = current_user.tasks
    @family_tasks = current_user.family.tasks.excluding(@user_tasks)
  end

  def show
    authorize @restaurant
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
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task)
    else
      render new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @task.update(task_params)
    redirect_to task_path(@task)
  end

  def destroy
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
      :task_template
    )
  end
end
