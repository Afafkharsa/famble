class AddIconToRewardTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :reward_templates, :icon, :string
  end
end
