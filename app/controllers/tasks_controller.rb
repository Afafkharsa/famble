class TasksController < ApplicationController
  def index
    @tasks = Task.all
    @user_tasks = current_user.tasks
  end
end
