require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:question) { create :question, title: 'Title for the Question', body: 'Some Body'  }

  describe 'GET #index' do
    before do
      allow(ThinkingSphinx).to receive(:search).and_return(question)
      get :index, params: { query: 'For' }
    end

    context 'with valid attributes' do
      it 'Status OK' do
        expect(response).to be_successful
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it 'question assign to results' do
        expect(assigns(:results)).to eq question
      end
    end
  end
end
