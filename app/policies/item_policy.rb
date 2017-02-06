class ItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    !user.nil? && user.admin?
  end

  def update?
    !user.nil? && user.admin?
  end

  def destroy?
    !user.nil? && user.admin?
  end
end
