class CreateTaskTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :task_templates do |t|
      t.string :name
      t.text :description
      t.integer :task_points

      t.timestamps
    end
  end
end
