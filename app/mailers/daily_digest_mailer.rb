class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.where("DATE(created_at) = ?", Date.yesterday)

    mail to: user.email, subject: "Daily Digest of Questions"
  end
end
