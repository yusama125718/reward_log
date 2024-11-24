class Master::JobController < ApplicationController
  def index
    @q = Job.ransack(params[:q])
    @jobs = @q.result.page(params[:page]).per(20)
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
      render :edit
    end
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to master_job_index_path, flash: { success: "作成しました" }
    else
      render :new
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
