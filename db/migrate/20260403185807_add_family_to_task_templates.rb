class AddFamilyToTaskTemplates < ActiveRecord::Migration[7.1]
  def change
    add_reference :task_templates, :family, foreign_key: true
  end
end
