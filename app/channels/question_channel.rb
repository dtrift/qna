class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'question_channel'
  end

  def unsubscribed
    stop_all_streams
  end
end
