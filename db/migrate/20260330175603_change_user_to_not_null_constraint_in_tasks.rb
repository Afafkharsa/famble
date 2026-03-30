class ChangeUserToNotNullConstraintInTasks < ActiveRecord::Migration[7.1]
  def change
      change_column_null :tasks, :family_member_id, false
  end
end
