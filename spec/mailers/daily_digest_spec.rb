require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "Daily digest" do
    let(:user) { create :user }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list :question, 3, user: user, created_at: Date.yesterday }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily Digest of Questions")
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(questions.last.title)
      expect(mail.body.encoded).to match(questions.first.body)
    end
  end
end
