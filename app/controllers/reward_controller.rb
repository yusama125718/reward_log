class RewardController < ApplicationController
  include Permission
  before_action :require_gm

  def index
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.page(params[:page]).per(20)
  end

  def job_index
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.group(:job_id).page(params[:page]).per(20)
    render :index
  end

  def content_index
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.group(:content_type_id).page(params[:page]).per(20)
    render :index
  end

  def new
    @content = RewardContent.new()
  end

  def edit
    @content = RewardContent.find_by(id: params[:id])
  end

  def update
    @content = RewardContent.find_by(id: params[:id])
    p = content_params
    p[:user_id] = @current_user.id
    if @content.update(p)
      redirect_to reward_index_path, flash: { success: "保存しました" }
    else
      render :edit
    end
  end

  def create
    p = content_params
    p[:user_id] = @current_user.id
    @content = RewardContent.new(p)
    if @content.save
      redirect_to reward_index_path, flash: { success: "作成しました" }
    else
      render :new
    end
  end

  def destroy
    target = RewardContent.find_by(id: params[:id])
    if target.destroy
      redirect_to reward_index_path, flash: { success: "削除しました" }
    else
      redirect_to reward_index_path, flash: { success: "削除しました" }
    end
  end

  private

  def content_params
    params.require(:reward_content).permit(:title, :amount, :note, :confirm_date, :jobs_id, :content_type_id, :worker, :job_id)
  end
end
