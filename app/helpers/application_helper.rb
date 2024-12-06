module ApplicationHelper
  def is_admin?
    allow_permissions = ["admin"]
    return allow_permissions.include?(@current_user.permission)
  end

  def is_gm?
    allow_permissions = ["admin", "gm"]
    return allow_permissions.include?(@current_user.permission)
  end

  def get_permission_select(all: true)
    if all
      array = [["Admin", "admin"], ["GM", "gm"], ["Helper", "helper"]]
    else
      array = [["Helper", "helper"]]
      array += ["GM", "gm"] if is_gm?
      array += ["Admin", "admin"] if is_admin?
    end
    array
  end
end
