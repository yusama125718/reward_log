class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  layout false

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:name, :password))
      start_new_session_for user
      redirect_to after_authentication_url, flash: { success: "ログインしました" }
    else
      redirect_to new_session_path, flash: { warning: "ユーザー名又はパスワードが間違っています" }
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other, flash: { success: "ログアウトしました" }
  end
end
