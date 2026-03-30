class ChangeStatusToBooleanInTasks < ActiveRecord::Migration[7.1]
  def change
    change_column :tasks, :status, 'boolean USING CAST(status AS boolean)'
  end
end
