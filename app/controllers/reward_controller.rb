class RewardController < ApplicationController
  include Permission
  before_action :require_gm

  def index
    get_select(params[:q])
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.page(params[:page])
  end

  def job_index
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.select("reward_contents.*, SUM(amount) AS amount_sum").group(:job_id).page(params[:page])
    render :index
  end

  def content_index
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.group(:content_type_id).sum(:amount).page(params[:page])
    render :index
  end

  def new
    @select = {}
    @content = RewardContent.new()
  end

  def edit
    @select = {}
    @content = RewardContent.find_by(id: params[:id])
  end

  def update
    @content = RewardContent.find_by(id: params[:id])
    p = content_params
    p[:user_id] = @current_user.id
    if @content.update(p)
      redirect_to reward_index_path, flash: { success: "保存しました" }
    else
      get_input_select(params[:reward_content])
      @url = reward_path(@content.id)
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    p = content_params
    p[:user_id] = @current_user.id
    @content = RewardContent.new(p)
    if @content.save
      redirect_to reward_index_path, flash: { success: "作成しました" }
    else
      get_input_select(params[:reward_content])
      @url = reward_index_path
      render :new, status: :unprocessable_entity
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

  def open_modal
    if params[:target].eql?("content_type")
      @q = ContentType.ransack(params[:q])
      @content_types = @q.result.page(params[:modal_page]).per(8)
      @modal_title = "コンテント種別選択"
      @content = "/reward/content_type"
    elsif params[:target].eql?("job")
      @q = Job.ransack(params[:q])
      @jobs = @q.result.page(params[:modal_page]).per(8)
      @modal_title = "仕事選択"
      @content = "/reward/job"
    end
    render "/shared/open_modal"
  end

  def set_modal_params
    if params[:value].blank?
      @object = nil
    elsif params[:target].eql?("content_type")
      @object = ContentType.find_by(id: params[:value])
    elsif params[:target].eql?("job")
      @object = Job.find_by(id: params[:value])
    end
    @target = params[:target]
  end

  def serch_content_type
    @q = ContentType.ransack(params[:q])
    @content_types = @q.result.page(params[:modal_page]).per(8)
  end

  def serch_job
    @q = Job.ransack(params[:q])
    @jobs = @q.result.page(params[:modal_page]).per(8)
  end

  private

  def get_select(p)
    @select = {}
    if p
      @select[:job] = Job.find_by(id: p[:job_id_eq]).name unless p[:job_id_eq].blank?
      @select[:content_type] = ContentType.find_by(id: p[:content_type_id_eq]).name unless p[:content_type_id_eq].blank?
    end
  end

  def get_input_select(p)
    @select = {}
    if p
      @select[:job] = Job.find_by(id: p[:job_id]).name unless p[:job_id].blank?
      @select[:content_type] = ContentType.find_by(id: p[:content_type_id]).name unless p[:content_type_id].blank?
    end
  end

  def content_params
    params.require(:reward_content).permit(:title, :amount, :note, :confirm_date, :jobs_id, :content_type_id, :worker, :job_id)
  end
end
