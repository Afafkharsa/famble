class AddValidationToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :validation, :boolean, :default => false
  end
end
