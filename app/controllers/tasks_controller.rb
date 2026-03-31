class TasksController < ApplicationController
  def index
    @family_tasks = current_user.family.tasks
    @tasks = Task.all
    @user_tasks = current_user.tasks
  end
end
