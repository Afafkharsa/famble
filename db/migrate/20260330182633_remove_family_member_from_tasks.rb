class RemoveFamilyMemberFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :family_member_id, :integer
  end
end
