class UserPolicy < ApplicationPolicy
  def index?
    false
  end

  def create?
    true
  end

  def update?
    !user.nil? && user.id == record.id
  end

  def destroy?
    false
  end
end
