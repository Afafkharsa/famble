class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @role = current_user.role
    @user_tasks = current_user.tasks
    @family_tasks = current_user.family.tasks
  end

  def show
  end

  def new
    @task= Task.new()
  end

  def create
    @task = Task.new(params[:task])
    @task.user = current_user
    if @restaurant.save
      redirect_to task_path(@task)
    else
      render new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.update(restaurant_params)
    redirect_to task_path(@task)
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, status: :see_other
  end

  private

  def set_restaurant
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :name,
      :description,
      :status,
      :start_date,
      :end_date,
      :task_points,
      :frequency
    )
  end
end
