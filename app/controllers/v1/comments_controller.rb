class V1::CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    params[:page].blank? ? @page = 1 : @page = params[:page]
    if @comment.save
      if @comment.commentable_type == 'Task'
        render json: { data:  TaskSerializer.new(@comment.commentable, scope: {user_id: current_user.id}, page: @page).as_json, klass: 'Task'}, status: :ok
      end
      if @comment.commentable_type == 'Work'
        render json: { data:  WorkSerializer.new(@comment.commentable, scope: {user_id: current_user.id}, page: @page).as_json, klass: 'Work'}, status: :ok
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    params[:page].blank? ? @page = 1 : @page = params[:page]
    @cm = @comment
    if is_valid?(@cm.commentable, 'edit') &&  @comment.destroy
      if @cm.commentable_type == 'Task'
        render json: { data:  TaskSerializer.new(@cm.commentable, scope: {user_id: current_user.id}, page: @page).as_json, klass: 'Task'}, status: :ok
      end
      if @cm.commentable_type == 'Work'
        render json: { data:  WorkSerializer.new(@cm.commentable, scope: {user_id: current_user.id}, page: @page).as_json, klass: 'Work'}, status: :ok
      end
    end
  end

  def comment_params
    params.require(:comment).permit!
  end
end
