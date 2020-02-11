require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:author) { create :user }
  let(:user) { create :user }
  let!(:question) { create :question, user: author }
  let!(:link) { create :link, linkable: question }

  describe 'DELETE #destroy' do
    context 'Authenticated Author' do
      it 'delete the link' do
        login author

        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'reder template destroy' do
        login author
        
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated User' do
      it 'trying to delete link' do
        login user

        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end
    end

    context 'Guest' do
      it 'trying to delete link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
