class UserPolicy < ApplicationPolicy
  def edit?
    user.role == "parent"
  end

  def update?
    user.role == "parent"
  end

  def destroy?
    user.role == "parent"
  end
end
