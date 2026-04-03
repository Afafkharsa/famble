class AddDaysToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :days, :text
  end
end
