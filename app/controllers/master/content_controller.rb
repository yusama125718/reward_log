class Master::ContentController < ApplicationController
  include Permission
  before_action :require_gm

  def index
    @q = ContentType.ransack(params[:q])
    @contents = @q.result.page(params[:page])
  end

  def paginate
    @q = ContentType.ransack(params[:q])
    @contents = @q.result.page(params[:page])
  end

  def new
    @content = ContentType.new()
  end

  def edit
    @content = ContentType.find_by(id: params[:id])
  end

  def update
    @content = ContentType.find_by(id: params[:id])
    if @content.update(content_params)
      redirect_to master_content_index_path, flash: { success: "保存しました" }
    else
      @url = master_content_path(@content.id)
      render :form_update, status: :unprocessable_entity
    end
  end

  def create
    @content = ContentType.new(content_params)
    if @content.save
      redirect_to master_content_index_path, flash: { success: "作成しました" }
    else
      @url = master_content_index_path
      render :form_update, status: :unprocessable_entity
    end
  end

  def destroy
    target = ContentType.find_by(id: params[:id])
    if RewardContent.where(content_type_id: target.id).exists?
      redirect_to master_content_index_path, flash: { warning: "紐づいているコンテンツがあるため削除できません" }
      return
    end
    if target.destroy
      redirect_to master_content_index_path, flash: { success: "削除しました" }
    else
      redirect_to master_content_index_path, flash: { success: "削除しました" }
    end
  end

  private

  def content_params
    params.require(:content_type).permit(:name, :note, :state)
  end
end
