class AddMontlyFrequencyToTaskTemplate < ActiveRecord::Migration[7.1]
  def change
    add_column :task_templates, :montly_frequency, :integer
  end
end
