class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :find_resource, only: %i[create]
  after_action :publish_comment, only: %i[create]

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash.now[:notice] = 'Comment posted successfully'
    end
  end

  private

  def find_resource
    @klass = [Question, Answer].find { |klass| params["#{klass.name.underscore}_id"] }
    @resource = @klass.find(params["#{@klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def publish_comment
    return if @comment.errors.present?

    question_id = @klass == Question ? @resource.id : @resource.question.id

    ActionCable.server.broadcast(
      "question-#{question_id}-comments",
        comment: @comment,
        resource_id: @comment.commentable_id,
        resource_type: @comment.commentable_type,
        user_email: @comment.user.email,
        id: @resource.id
        )
  end
end
