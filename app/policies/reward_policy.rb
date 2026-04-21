class RewardPolicy < ApplicationPolicy
  def edit?
    user.role == "parent" || record.user == user
  end

  def update?
    user.role == "parent" || record.user == user
  end

  def destroy?
    user.role == "parent" || record.user == user
  end
end
