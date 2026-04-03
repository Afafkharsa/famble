class TaskTemplatesController < ApplicationController
  def index
    @task_templates = TaskTemplate.all
  end
end
