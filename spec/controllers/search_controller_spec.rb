require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:question) { create :question, title: 'Title for the Question', body: 'Some Body'  }

  describe 'GET #index' do
    context 'with valid attributes' do
      before do
        allow(SearchService).to receive(:call).and_return(question)

        get :index, params: { query: 'For', resource: 'All' }
      end

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