class AddPointsResetAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :points_reset_at, :datetime
  end
end
