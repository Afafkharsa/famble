class PointAdjustmentPolicy < ApplicationPolicy
  def create?
    user.role == "parent"
  end
end
