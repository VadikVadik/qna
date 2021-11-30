module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :create_comment
    after_action :publish_comment, only: :create_comment
  end

  def create_comment
    @comment = @commentable.comments.create(comment_params.merge(author: current_user))

    if @comment.errors.any?
      respond_to do |format|
        format.json do
          render json: {errors: @comment.errors.full_messages,
                        commentable_id: @commentable.id,
                        commentable_type: @comment.commentable_type},
                        status: :unprocessable_entity
        end
      end
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?
    CommentsChannel.broadcast_to(@commentable, @comment)
  end

  def commentable_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = commentable_klass.find(params[:id])
  end

  def comment_params
    params.permit(:body)
  end
end
