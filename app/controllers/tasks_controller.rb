class TasksController < ApplicationController
  def index
    @user = current_user
    @tasks = Task.all
    @user_tasks = current_user.tasks
  end
end
