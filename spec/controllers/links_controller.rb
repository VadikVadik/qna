require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:link) { create(:link, linkable: question) }
    let(:another_user) { create(:user) }

    context 'by the author' do
      before { login(author) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end
    end

    context 'not by the author' do
      before { login(another_user) }

      it "can't delete link" do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end
    end
  end
end
