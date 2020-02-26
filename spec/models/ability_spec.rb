require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, :all } 
  end

  describe 'for Admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for User' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }

    let(:other_user) { create :user }
    let(:other_question) { create :question, user: other_user }    
    let(:other_answer) { create :answer, question: question, user: other_user }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :best, answer, user: user }

  end
end
