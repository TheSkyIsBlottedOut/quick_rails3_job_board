class InboxController < ApplicationController
  include ApplicationHelper
  def index
    @messages = Comment.paginate(joins: 'LEFT JOIN jobs ON jobs.id = comments.job_id', conditions: ['jobs.user_id = :user_id', {user_id: session[:user_id]}], per_page: 10, page: params[:page], order: 'created_at DESC')
    respond_to do |format|
      if current_user
        format.html
        format.json { render json: @messages }
      else
        format.html { redirect_to '/login', notice: 'You need to log in before checking your inbox!' }
        format.json { render status: 'Failure' }
      end
    end
  end
  
  def view
    @message = Comment.find(params[:id])
    respond_to do |format|
      if @message.job.user == current_user
        format.html
        format.json { render json: @messages, status: 'Success' }
      else
        format.html { redirect_to '/', notice: 'You do not have access to this message.' }
        format.json { render json: nil, status: 'Failure'}
      end
    end
  end

  def delete
    @message = Comment.find(params[:id])
    respond_to do |format|
      if @message.job.user == current_user
        @message.destroy
        format.html { redirect_to '/inbox', notice: 'Message deleted.' }
        format.json { render json: @messages, status: 'Success' }
      else
        format.html { redirect_to '/', notice: 'You do not have access to this message.' }
        format.json { render json: nil, status: 'Failure'}
      end
    end
  end
  
  
  
end
