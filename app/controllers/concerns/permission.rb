module Permission
  extend ActiveSupport::Concern
  included do
    before_action :get_user
  end

  def get_user
    @current_user = resume_session.try(:user)
  end

  def require_admin
    allow_permissions = ["admin"]
    unless allow_permissions.include?(@current_user.permission)
      redirect_to root_path, flash: { warning: "権限がありません" }
    end
  end

  def require_gm
    allow_permissions = ["admin", "gm"]
    unless allow_permissions.include?(@current_user.permission)
      redirect_to root_path, flash: { warning: "権限がありません" }
    end
  end
end