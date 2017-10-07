class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user

  def index
   @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクを追加しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'タスクの追加に失敗しました。'
      render 'toppages/index'
    end
  end
  
  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました。'
    redirect_to @task
  end
  
  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'task は更新されませんでした'
      render :edit
    end
  end


  private

  def task_params
    params.require(:task).permit(:content,:status)
  end

  def correct_user
    @task = current_user.tasks.find_by(params[:id])
    unless @task
      redirect_to root_url
    end
  end
end