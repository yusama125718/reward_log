class PasswordsController < ApplicationController
  def edit
    @user = resume_session.user
    if @user.nil?
      redirect_to root_path, flash: { warning: "ユーザーが見つかりませんでした。ログインし直して再度編集して下さい" }
    end
  end

  def update
    user = find_session_by_cookie.user
    # 念の為権限は更新できないように
    unless params[:permission].blank?
      redirect_to root_path, flash: { warning: "権限は変更できません" }
      return
    end
    if user.update(params.permit(:password, :password_confirmation, :name, :display))
      redirect_to root_path, flash: { success: "ユーザー情報を変更しました" }
    else
      redirect_to passwords_edit_path, flash: { warning: "変更時にエラーが発生しました。パスワードが一致しているか確認してください" }
    end
  end
end
