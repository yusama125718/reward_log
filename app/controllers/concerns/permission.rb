module Permission
  extend ActiveSupport::Concern
  included do
    before_action :get_user
  end

  def get_user
    @current_user = resume_session.try(:user)
  end

  def require_admin
    unless is_admin?
      redirect_to root_path, flash: { warning: "権限がありません" }
    end
  end

  def require_gm
    unless is_gm?
      redirect_to root_path, flash: { warning: "権限がありません" }
    end
  end

  def is_admin?
    allow_permissions = ["admin"]
    return allow_permissions.include?(@current_user.permission)
  end

  def is_gm?
    allow_permissions = ["admin", "gm"]
    return allow_permissions.include?(@current_user.permission)
  end
end