class Master::DisplayController < ApplicationController
  include Permission
  before_action :require_gm

  def index
    @q = DisplayType.ransack(params[:q])
    @displays = @q.result.page(params[:page])
  end

  def paginate
    @q = DisplayType.ransack(params[:q])
    @displays = @q.result.page(params[:page])
  end

  def new
    @display = DisplayType.new()
  end

  def edit
    @display = DisplayType.find_by(id: params[:id])
  end

  def update
    @display = DisplayType.find_by(id: params[:id])
    if @display.update(display_params)
      redirect_to master_display_index_path, flash: { success: "保存しました" }
    else
      @url = master_display_path(@display.id)
      render :form_update, status: :unprocessable_entity
    end
  end

  def create
    @display = DisplayType.new(display_params)
    if @display.save
      redirect_to master_display_index_path, flash: { success: "作成しました" }
    else
      @url = master_display_index_path
      render :form_update, status: :unprocessable_entity
    end
  end

  def destroy
    target = DisplayType.find_by(id: params[:id])
    if Display.where(display_type_id: target.id).exists?
      redirect_to master_display_index_path, flash: { warning: "紐づいているコンテンツがあるため削除できません" }
      return
    end
    if target.destroy
      redirect_to master_display_index_path, flash: { success: "削除しました" }
    else
      redirect_to master_display_index_path, flash: { success: "削除しました" }
    end
  end

  private

  def display_params
    params.require(:display_type).permit(:name, :target_path, :permission, :note)
  end
end
