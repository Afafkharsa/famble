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
    @task= Task.new({status: false, user: current_user})
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
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
