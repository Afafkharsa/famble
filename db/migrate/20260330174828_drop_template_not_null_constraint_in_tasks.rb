class DropTemplateNotNullConstraintInTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :task_template_id, true
  end
end
