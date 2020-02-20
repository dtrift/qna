class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['question_id']}-comments"
  end

  def subscribed; end

  def unsubscribed; end
end
