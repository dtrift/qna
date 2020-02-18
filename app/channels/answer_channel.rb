class AnswerChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['question_id']}-answers"
    # stream_from 'answer_channel', question_id: data.gon.question_id
    # ActionCable.server.broadcast "answer_channel", question_id: data['gon.question_id']
  end

  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
