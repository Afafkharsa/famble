class RenameFrequencyToMontlyFrequencyInTasks < ActiveRecord::Migration[7.1]
  def change
    rename_column :tasks, :frequency, :montly_frequency
  end
end
