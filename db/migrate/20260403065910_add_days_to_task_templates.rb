class AddDaysToTaskTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :task_templates, :days, :text, array: true, default: []
  end
end
