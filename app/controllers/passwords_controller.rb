class PasswordsController < ApplicationController
  def edit
    @user = find_session_by_cookie.user
  end

  def update
    user = find_session_by_cookie.user
    if user.update(params.permit(:password, :password_confirmation))
      redirect_to after_authentication_url, flash: { success: "パスワードを変更しました" }
    else
      redirect_to passwords_edit_path, flash: { warning: "パスワードが一致しません" }
    end
  end
end
