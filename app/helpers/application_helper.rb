module ApplicationHelper
  def is_admin?
    allow_permissions = ["admin"]
    return allow_permissions.include?(@current_user.permission)
  end

  def is_gm?
    allow_permissions = ["admin", "gm"]
    return allow_permissions.include?(@current_user.permission)
  end
end
