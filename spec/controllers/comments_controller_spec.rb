require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:comment) { create(:comment, commentable: question, author: author) }
    let(:another_user) { create(:user) }

    context 'by the author' do
      before { login(author) }

      it 'deletes the comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(question.comments, :count).by(-1)
      end
    end

    context 'not by the author' do
      before { login(another_user) }

      it "can't delete comment" do
        expect { delete :destroy, params: { id: comment }, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
