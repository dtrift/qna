require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User is an author' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, question: question, author: user }

    it 'of the question' do
      expect(user).to be_author(question)
    end

    it 'of the answer' do
      expect(user).to be_author(answer)
    end
  end
end
