class RewardController < ApplicationController
  require "net/http"
  include Permission
  before_action :require_gm

  def index
    get_select(params[:q])
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.preload(:job, :content_type, :user).page(params[:page])
  end

  def job_index
    @q = Job.ransack(params[:q])
    @contents = @q.result.select("jobs.id, jobs.name, (SELECT SUM(amount) FROM reward_contents WHERE job_id = jobs.id) AS amount, (SELECT COUNT(*) FROM reward_contents WHERE job_id = jobs.id) AS records_count").page(params[:page])
  end

  def content_index
    @q = ContentType.ransack(params[:q])
    @contents = @q.result.select("content_types.id, content_types.name, (SELECT SUM(amount) FROM reward_contents WHERE content_type_id = content_types.id) AS amount, (SELECT COUNT(*) FROM reward_contents WHERE content_type_id = content_types.id) AS records_count").page(params[:page])
  end

  def paginate
    @q = RewardContent.ransack(params[:q])
    @contents = @q.result.page(params[:page])
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

  def show
    @content = RewardContent.find_by(id: params[:id])
  end

  def create
    p = content_params
    p[:user_id] = @current_user.id
    @content = RewardContent.new(p)
    if @content.save
      if Settings.try(:reward).try(:webhook)
        params = { content: "#{@current_user.display}が新しい報酬を登録しました。\n"+
                            "```#{p[:title]}\n"+
                            "#{p[:worker]}：#{p[:amount].to_i.to_formatted_s(:delimited)}```" }
        uri = URI.parse(Settings.reward.webhook)
        response = Net::HTTP.post_form(uri, params)

        Rails.logger.info(response.code)
        Rails.logger.info(response.body)
      end
      redirect_to reward_index_path, flash: { success: "作成しました" }
    else
      get_input_select(params.try(:reward_content))
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

  def get_select(prm)
    @select = {}
    if prm
      @select[:job] = Job.find_by(id: prm[:job_id_eq]).name unless prm[:job_id_eq].blank?
      @select[:content_type] = ContentType.find_by(id: prm[:content_type_id_eq]).name unless prm[:content_type_id_eq].blank?
    end
  end

  def get_input_select(prm)
    @select = {}
    if prm
      @select[:job] = Job.find_by(id: prm[:job_id]).name unless prm[:job_id].blank?
      @select[:content_type] = ContentType.find_by(id: prm[:content_type_id]).name unless prm[:content_type_id].blank?
    end
  end

  def content_params
    params.require(:reward_content).permit(:title, :amount, :note, :confirm_date, :content_type_id, :worker, :job_id)
  end
end
