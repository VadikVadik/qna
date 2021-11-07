require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }

    context 'with valid attributes' do
      before { login(author) }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' }, format: :js }
        answer.reload
        expect(answer.body).to eq 'New body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'New body' }, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :update
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
        expect { delete :destroy, params: { id: answer, question_id: question.id }, format: :js }.to change(author.answers, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer, question_id: question.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not by the author' do
      before { login(another_user) }

      it "can't delete the answer" do
        expect { delete :destroy, params: { id: answer, question_id: question.id }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer, question_id: question.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
