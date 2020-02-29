require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { {
    "ACCEPT" => "application/json"
  } }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:user) { create :user }
      let!(:questions) { create_list :question, 2, user: user }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list :answer, 3, user: user, question: question }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(4)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:question) { { title: 'Test Title', body: 'Test Body' } }
      let(:question_response) { json['question'] }

      let(:question_request) {
        post api_path, params: { 
          access_token: access_token.token,
          question: question
        }, headers: headers 
      }

      it 'returns status 201' do
        question_request
        expect(response.status).to eq 201
      end

      it 'saves question in database' do
        expect { question_request }.to change(Question, :count).by(1)
      end

      it 'returns all public fields' do
        question_request

        %w[id title body created_at updated_at user].each do |attr|
          expect(question_response[attr]).to eq Question.first.send(attr).as_json
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:user) { create :user }
    let!(:question) { create :question, user: user }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:new_params_for_question) { { title: 'New Title', body: 'New Body' } }
      let(:question_response) { json['question'] }

      let(:question_request) {
        patch api_path, params: { 
          access_token: access_token.token,
          question: new_params_for_question
        }, headers: headers 
      }

      it 'returns status 201' do
        question_request
        expect(response.status).to eq 201
      end

      it 'saves question in database with new params' do
        question_request
        expect(Question.last.body).to eq 'New Body'
      end

      it 'returns all public fields' do
        question_request
        %w[id title body created_at updated_at user].each do |attr|
          expect(question_response[attr]).to eq Question.first.send(attr).as_json
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:user) { create :user }
    let!(:question) { create :question, user: user }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:question_response) { json['question'] }

      let(:question_request) {
        delete api_path,
        params: { 
          access_token: access_token.token,
          question_id: question.id
        }, headers: headers 
      }

      it 'returns status 200' do
        question_request
        expect(response.status).to eq 200
      end

      it 'deletes the question from database' do
        expect { question_request }.to change(Question, :count).by(-1)
      end
    end
  end
end
