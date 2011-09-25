class JobsController < ApplicationController
  include ApplicationHelper
  def index
    @jobs = Job.page(params[:page]).order('created_at DESC')
    respond_to do |format|
      format.html
      format.json { render json: @jobs }
    end
  end
  
  def show
    @job = Job.find(params[:id])
    @comment = Comment.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end
  
  def new
    @job = Job.new

    respond_to do |format|
      if current_user
        format.html # new.html.erb
        format.json { render json: @job }
      else
        format.html { redirect_to '/login', notice: "You must login before creating a new job."}
        format.json { render json: nil, status: 'Failure' }
      end
    end
  end
  
  def edit
    @job = Job.find(params[:id])
    respond_to do |format|
      if @job.user == current_user
        format.html
        format.json { render json: nil, status: 'Success' }
      else
        format.html { redirect_to '/', notice: 'You do not have access to edit this item.' }
        format.json { render json: nil, status: 'Failure' }
      end
    end
  end
  

  # Job /jobs
  # Job /jobs.json
  def create
    @job = Job.new(params[:job])
    @job.user = current_user
    respond_to do |format|
      if !current_user
        format.html { redirect_to '/login', notice: 'You must login before creating jobs.'}
        format.json { render json: @job, status: 'Failed' }
      elsif @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @job = Job.find(params[:id])
    
    respond_to do |format|
      if @job.user != current_user
        format.html { redirect_to '/jobs', notice: 'You do not have access to edit this item.' }
        format.json { render json: nil, status: 'Failed' }
      elsif @job.update_attributes(params[:job])
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.user == current_user
        @job.destroy
        format.html { redirect_to jobs_url }
        format.json { head :ok }
      else
        format.html { redirect_to jobs_url, notice: 'Job deleted.' }
        format.json { render json: nil, status: 'Failed' }
      end
    end
  end
  
  #post /jobs/comment/1
  def comment
    @job = Job.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.job = @job
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to job_path(@job), notice: 'Comment created.' }
        format.json { render json: @comment, status: :success }
      else
        format.html { redirect_to job_path(@job), notice: 'Could not save comment.' }
        format.json { render json: @comment, status: 'Failed' }
      end
    end
  end

  
  
end
