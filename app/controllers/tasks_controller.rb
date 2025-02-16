class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = @current_user.tasks.page(params[:page]).per(10)
    render json: tasks, each_serializer: TaskSerializer
  end

  def show
    render json: @task
  end

  def create
    task = @current_user.tasks.build(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = @current_user.tasks.find_by(id: params[:id])
    render json: { error: 'Task not found' }, status: :not_found unless @task
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
