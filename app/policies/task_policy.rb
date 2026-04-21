class TaskPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      user.family.tasks
    end
  end

  def show?
    if user.role == "parent"
      true
    else
      record.user == user
    end
    #
    # record: the restaurant passed to the `authorize` method in controller
    # user: the `current_user` signed in with Devise
    # @user.role("company.destroy", record.id) if @user.present?
  end

  def edit?
    if user.role == "parent"
      true
    else
      false
    end
  end

  def update?
    if user.role == "parent"
      true
    else
      record.user == user
    end
  end

  def new?
    return create?
  end

  def create?
    if user.role == "parent"
      true
    else
      false
    end
  end

  def destroy?
    user.role == "parent"
  end
end
