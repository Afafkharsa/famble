class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :edit]

  def index
    @tasks = policy_scope(Task)
    @user = current_user
    @user_tasks = @tasks.where(user: @user)
    @family_tasks = @tasks.where.not(user: @user)
  end

  def show

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
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    authorize @task

    if @task.save
      redirect_to task_path(@task)
    else
      render new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      raise
      respond_to do |format|
        format.html { redirect_to task_path(@task), notice: "Task updated." }
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
    @task.destroy
    redirect_to tasks_path, status: :see_other
  end

  private

  def set_task
    @task = Task.find(params[:id])
    authorize @task
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
