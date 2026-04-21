class AddIconToRewards < ActiveRecord::Migration[7.1]
  def change
    add_column :rewards, :icon, :string
  end
end
