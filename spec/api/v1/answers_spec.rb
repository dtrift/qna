require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { {
    "ACCEPT" => "application/json"
  } }

  let(:access_token) { create :access_token }
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let!(:answers) { create_list :answer, 3, :add_file, user: user, question: question }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(answers_response.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list :comment, 3, user: user, commentable: answer }
      let(:comment) { comments.first }
      let(:comment_response) { answer_response['comments'].first }
      let!(:links) { create_list :link, 4, linkable: answer }

      let(:answer_request) {
        get api_path, params: {
          access_token: access_token.token,
          question_id: question.id
        }, headers: headers 
      }

      before { answer_request }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      context 'comments' do
        it 'are returned all' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id content created_at updated_at user_id].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      it 'returns links' do
        expect(answer_response['links'].size).to eq 4
      end

      it 'returns files' do
        expect(answer_response['files'].first.size).to eq 1 
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers/' do
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create :access_token }
      let(:answer) { { body: 'Test Title for Answer' } }
      let(:answer_response) { json['answer'] }

      let(:answer_request) {
        post api_path, params: {
          access_token: access_token.token,
          question_id: question.id,
          answer: answer,
        }, headers: headers 
      }

      it 'returns status 201' do
        answer_request
        expect(response.status).to eq 201
      end

      it 'saves question in database' do
        expect { answer_request }.to change(Answer, :count).by(1)
      end

      it 'returns all public fields' do
        answer_request
        %w[id body created_at updated_at user].each do |attr|
          expect(answer_response[attr]).to eq Answer.last.send(attr).as_json
        end
      end
    end
  end
end
