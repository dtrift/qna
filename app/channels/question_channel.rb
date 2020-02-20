class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'question_channel'
  end

  def unsubscribed; end
end
