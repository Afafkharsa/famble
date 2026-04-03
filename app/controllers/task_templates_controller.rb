class TaskTemplatesController < ApplicationController
  def index
    @role = current_user.role
    @familly = current_user.family
    @generic_templates = TaskTemplate.all.where("family_id IS NULL")
    @family_templates = current_user.family.task_templates
  end
end
