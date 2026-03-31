class TasksController < ApplicationController
  def index
    @role = current_user.role
    @family = current_user.family
    @user_tasks = current_user.tasks
    @family_tasks = @family.tasks
  end
end
