class Master::JobController < ApplicationController
  include Permission
  before_action :require_gm
  
  def index
    @q = Job.ransack(params[:q])
    @jobs = @q.result.page(params[:page])
  end

  def new
    @job = Job.new()
  end

  def edit
    @job = Job.find_by(id: params[:id])
  end

  def update
    @job = Job.find_by(id: params[:id])
    if @job.update(job_params)
      redirect_to master_job_index_path, flash: { success: "保存しました" }
    else
      @url = master_job_path(@job.id)
      render :form_update, status: :unprocessable_entity
    end
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to master_job_index_path, flash: { success: "作成しました" }
    else
      @url = master_job_index_path
      render :form_update, status: :unprocessable_entity
    end
  end

  def destroy
    target = Job.find_by(id: params[:id])
    if RewardContent.where(jobs_id: target.id).exists?
      redirect_to master_job_index_path, flash: { warning: "紐づいているコンテンツがあるため削除できません" }
      return
    end
    if target.destroy
      redirect_to master_job_index_path, flash: { success: "削除しました" }
    else
      redirect_to master_job_index_path, flash: { success: "削除しました" }
    end
  end

  private

  def job_params
    params.require(:job).permit(:name, :note)
  end
end
