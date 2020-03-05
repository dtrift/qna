require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:badges).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  let(:author) { create :user }
  let(:user) { create :user }
  let(:question) { create :question, user: author }
  let(:answer) { create :answer, question: question, user: author }

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123321') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed_of?' do
    let!(:subscription) { create :subscription, user: user, question: question }

    it 'subscribed of question' do
      expect(user).to be_subscribed_of(question)
    end
  end

  describe '#subscribe!' do
    it 'calls Subscription#create!' do
      expect { Question.create(attributes_for(:question).merge(user: user)) }
        .to change(user.subscriptions, :count).by(1)
    end
  end

  describe '#unsubscribe!' do
    let!(:subscription) { create :subscription, user: user, question: question }
    
    it 'calls Subscription#destroy!' do
      expect { question.destroy }.to change(user.subscriptions, :count).by(-1)
    end
  end

  describe 'User is an author' do
    it 'of the question' do
      expect(author).to be_author(question)
    end

    it 'of the answer' do
      expect(author).to be_author(answer)
    end
  end

  describe 'User is not an author' do
    it 'of the question' do
      expect(user).to_not be_author(question)
    end

    it 'of the answer' do
      expect(user).to_not be_author(answer)
    end
  end

  describe 'User positive voted' do
    before { question.positive(user) }

    it 'for the question' do
      expect(user).to be_voted(question)
    end
  end

  describe 'User negative voted' do
    before { question.negative(user) }

    it 'for the question' do
      expect(user).to be_voted(question)
    end
  end
end
