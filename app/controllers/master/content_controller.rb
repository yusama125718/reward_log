class Master::ContentController < ApplicationController
  def index
    @q = ContentType.ransack(params[:q])
    @contents = @q.result.page(params[:page]).per(20)
  end

  def new
    @content = ContentType.new()
  end

  def edit
    @content = ContentType.find_by(id: params[:id])
  end

  def update
    p = content_params
    if p[:state].blank?
      p[:state] = false
    end
    @content = ContentType.find_by(id: params[:id])
    if @content.update(p)
      redirect_to master_content_index_path, flash: { success: "保存しました" }
    else
      render :edit
    end
  end

  def create
    p = content_params
    if p[:state].blank?
      p[:state] = false
    end
    @content = ContentType.new(p)
    if @content.save
      redirect_to master_content_index_path, flash: { success: "作成しました" }
    else
      render :new
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
