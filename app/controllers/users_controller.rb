class UsersController < ApplicationController
  include Permission
  before_action :require_admin

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(20)
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, flash: { success: "作成しました" }
    else
      render :new
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.permission == "admin" && User.where(permission: "admin").count == 1 && !params[:permission].eql?("admin")
      flash.now[:warning] = "admin権限は0名にできません"
      render :show
      return
    end
    if @user.update(user_params)
      redirect_to users_path, flash: { success: "保存しました" }
    else
      render :show
    end
  end

  def destroy
    target = User.find_by(id: params[:id])
    if target.permission == "admin" && User.where(permission: "admin").count == 1
      redirect_to users_path, flash: { warning: "admin権限は0名にできません" }
      return
    end
    if target.destroy
      redirect_to users_path, flash: { success: "削除しました" }
    else
      redirect_to users_path, flash: { success: "削除しました" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :display, :password, :password_confirmation, :permission)
  end
end
