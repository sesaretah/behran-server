class V1::TasksController < ApplicationController
  before_action :record_visit, only: [:show]
  
  def index
    params['order'] == 'title' ? tasks = Task.order_by_title_for_user(current_user)  : tasks = Task.order_by_deadline_for_user(current_user) 
    
    render json: { data: ActiveModel::SerializableResource.new(tasks, user_id: current_user.id,  each_serializer: TaskSerializer, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
  end

  def change_role
    @task = Task.find(params[:id])
    @task.change_role(params[:profile_id], params[:role]) if is_valid?(@task , 'participants')
    render json: { data: TaskSerializer.new(@task, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
  end

  def add_participants
    @task = Task.find(params[:id])
    @task.add_participant(params[:profile_id]) if is_valid?(@task , 'participants')
    render json: { data: TaskSerializer.new(@task, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
  end

  def change_status
    @task = Task.find(params[:id])
    @task.status_id = params[:status_id]
    @task.save if is_valid?(@task, 'statuses')
    render json: { data: TaskSerializer.new(@task, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
  end

  def remove_participants
    @task = Task.find(params[:id])
    @task.remove_participant(params[:profile_id]) if is_valid?(@task, 'participants', )
    render json: { data: TaskSerializer.new(@task, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
  end


  def show
    @task = Task.find(params[:id])
    if is_valid?(@task, 'view')
      render json: { data:  TaskSerializer.new(@task, user_id: current_user.id, scope: {user_id: current_user.id}).as_json, klass: 'Task'}, status: :ok
    else 
      render json: { data:  [], klass: 'Task'}, status: :ok
    end
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      @task.append_tags
      render json: { data: TaskSerializer.new(@task).as_json, klass: 'Task' }, status: :ok
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.user_id = current_user.id
    if @task.update_attributes(task_params)
      @task.append_tags
      render json: { data: TaskSerializer.new(@task, scope: {user_id: current_user.id} ).as_json, klass: 'Task' }, status: :ok
    else
      render json: { data: @task.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end


  def task_params
    params.require(:task).permit!
    #params.permit!
  end
end