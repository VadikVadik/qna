class CommentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.commentable.instance_of?(Question)
      @question = @comment.commentable
    elsif @comment.commentable.instance_of?(Answer)
      @question = @comment.commentable.question
    end

    @comment.destroy if current_user.author_of?(@comment.commentable)
  end
end
