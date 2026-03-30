class RemoveTaskTemplateFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_reference :tasks, :task_template, null: false, foreign_key: true
  end
end
