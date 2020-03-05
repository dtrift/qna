class NewAnswerDigestService
  def send_notification(answer)
    subscribers = answer.question.includes(:subscribers)

    subscribers.find_each do |user|
      NewAnswerDigestMailer.send_for(user, answer).deliver_later
    end
  end
end
