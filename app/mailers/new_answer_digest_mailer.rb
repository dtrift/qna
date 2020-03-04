class NewAnswerDigestMailer < ApplicationMailer
  def send_for(answer)
    @answer = answer

    mail to: answer.question.user.email,
      subject: "New Answer for question #{answer.question.title}"
  end
end
