require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:a_user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }

  describe 'POST #create' do
    before { login user }

    context 'with valid attributes' do
      it 'saves a new answer in the DB' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(question.answers, :count).by(1)
      end

      it 'the author of the answer is an authenticated user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(assigns(:answer).author).to eq user
      end

      it 'redirects to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }
          .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login user }

    context 'Author can deletes his answer' do
      let!(:answer) { create :answer, question: question, author: user }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not the author deletes answer' do
      let(:a_user) { create :user }
      let!(:answer) { create :answer, question: question, author: a_user }

      it 'try delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders questions/show' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
