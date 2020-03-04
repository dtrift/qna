class NewAnswerDigestService
  def send_notification(answer)
    NewAnswerDigestMailer.send_for(answer).deliver_later
  end
end
