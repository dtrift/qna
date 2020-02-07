require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:author) { create :user }
  let(:user) { create :user }
  let!(:question) { create :question, user: author }
  let!(:answer) { create :answer, :add_file, question: question, user: author }

  describe 'DELETE #destroy' do
    before { login author }

    context 'Authenticated Author' do
      it 'delete the attachment' do
        expect { delete :destroy, params: { id: answer.files.first, question_id: question }, format: :js }
          .to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'reder template destroy' do
        delete :destroy, params: { id: answer.files.first, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated Non author' do
      let!(:second_answer) { create(:answer, :add_file, question: question, user: user) }

      it 'trying to delete another attachment' do
        expect { delete :destroy, params: { id: second_answer.files.first, question_id: question }, format: :js }
          .to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
