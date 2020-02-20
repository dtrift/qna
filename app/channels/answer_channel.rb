class AnswerChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['question_id']}-answers"
  end

  def subscribed; end

  def unsubscribed; end
end
