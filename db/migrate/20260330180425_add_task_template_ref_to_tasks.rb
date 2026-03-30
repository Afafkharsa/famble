class AddTaskTemplateRefToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :task_template, null: true, foreign_key: true
  end
end
