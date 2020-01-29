require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to :question }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe '#set_best!' do
    let(:author) { create :user }
    let(:question) { create :question, user: author }
    let(:answer) { create :answer, question: question, user: author }
    let!(:best_answer) { create :answer, question: question, user: author, best: true }

    it 'answer set as best' do
      answer.set_best!

      expect(answer).to be_best
    end

    it 'set another answer as best' do
      answer.set_best!
      best_answer.reload

      expect(best_answer).to_not be_best
    end
  end
end
