class AddFamilyToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :family, null: false, foreign_key: true
  end
end
