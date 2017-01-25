class OrderPolicy < ApplicationPolicy

  def index?
    false
  end

  def create?
    !user.nil?
  end

  def update?
    (user.user? && user.id == record.user_id) || user.admin?
  end

  def destroy?
    (user.user? && user.id == record.user_id) || user.admin?
  end

end
