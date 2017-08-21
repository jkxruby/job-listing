class Admin::JobsController < ApplicationController
before_action :authenticate_user!
before_action :require_is_admin

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user
    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
      redirect_to admin_jobs_path,notice: "admin update success"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to admin_jobs_path,alert: "admin deleted"
  end

  def require_is_admin?
    if !current_user.admin?
      flash[:alert] = "you have no admin"
      redirect_to root_path
    end
  end

  private
  def job_params
    params.require(:job).permit(:title, :description)
  end




end
