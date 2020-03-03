class DailyDigestService
  def send_digest
    User.all.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
