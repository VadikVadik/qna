require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(question.answers, :count)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }
    let(:another_user) { create(:user) }

    context 'by the author' do
      before { login(author) }

      it 'deletes the created answer' do
        expect { delete :destroy, params: { id: answer, question_id: question.id } }.to change(author.answers, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer, question_id: question.id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not by the author' do
      before { login(another_user) }

      it "can't delete the answer" do
        expect { delete :destroy, params: { id: answer, question_id: question.id } }.to_not change(Answer, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer, question_id: question.id }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
