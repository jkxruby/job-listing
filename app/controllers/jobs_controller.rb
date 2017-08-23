class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]

  def index
    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.where(is_hidden: false).order('wage_lower_bound DESC')
            when 'by_upper_bound'
              Job.where(is_hidden: false).order('wage_upper_bound DESC')
            else

              @jobs = Job.where(is_hidden: false).order('created_at DESC')
  end
  end

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = 'This job already archieved'
      redirect_to root_path
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user
    if @job.save
      redirect_to jobs_path
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
      redirect_to jobs_path, notice: 'update success'
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, alert: 'deleted'
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email)
  end
end
