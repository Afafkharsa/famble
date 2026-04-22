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
    authorize @task
  end

  def new
    @task= Task.new({
      user_id: params[:user],
      name: params[:name],
      description: params[:description],
      task_points: params[:task_points],
      days: params[:days],
      task_template_id: params[:task_template]
    })
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    @users = current_user.family.users
    @task.days = @task.days.reject(&:blank?)

    authorize @task

    if @task.save
      create_child_tasks
      redirect_to task_path(@task)
    else
      render :new, status: :unprocessable_entity
    end


  end

  def edit
    authorize @task
  end

  def update
    @task = Task.find(params[:id])
    @users = current_user.family.users

    authorize @task

    if @task.update(task_params)
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
      :montly_frequency,
      :task_template,
      :validation,
      days: []
    )
  end

  def create_child_tasks
    name_to_wday = {
      "sunday" => 0,
      "monday" => 1,
      "tuesday" => 2,
      "wednesday" => 3,
      "thursday" => 4,
      "friday" => 5,
      "saturday" => 6
    }
    p = task_params
    wdays = @task.days.map { |n| name_to_wday[n.downcase] }.compact
    tasks = []

    (@task.start_date + 1 .. @task.end_date).each do |date|
      next unless wdays.include?(date.wday)

      attrs = p.except(:start_date, :end_date, :days, :montly_frequency).merge(
        start_date: date,
        end_date: date
      )

      tasks << Task.create!(attrs)
    end
  end
end
