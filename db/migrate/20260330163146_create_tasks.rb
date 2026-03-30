class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :family_member, foreign_key: { to_table: :users }
      t.string :status
      t.date :start_date
      t.date :end_date
      t.integer :task_points
      t.integer :frequency
      t.references :task_template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
