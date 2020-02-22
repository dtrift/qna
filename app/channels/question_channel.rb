class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'question_channel'
  end
# stop_all_streams
end
