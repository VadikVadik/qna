require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: "New title", body: "New body" }, format: :js }
        question.reload

        expect(question.title).to eq "New title"
        expect(question.body).to eq "New body"
      end

      it 'rrenders update view' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not changes question attributes' do
        question.reload

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:another_user) { create(:user) }

    context 'by the author' do
      before { login(author) }

      it 'deletes the created question' do
        expect { delete :destroy, params: { id: question } }.to change(author.questions, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not by the author' do
      before { login(another_user) }

      it "can't delete the question" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end
    end
  end

  describe 'POST #subscribe' do
    before { login(user) }

    context 'with valid attributes' do
      it 'add new subscriber to question' do
        expect { post :subscribe, params: { id: question } }.to change(QuestionSubscription, :count).by(1)
      end
    end
  end

  describe 'DELETE #unsubscribe' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:another_user) { create(:user) }
    let!(:another_question) { create(:question, author: another_user) }

    before do
      login(user)
      user.subscriptions.push(question)
    end

    context 'with valid attributes' do
      it 'delete subscriber from question' do
        expect { delete :unsubscribe, params: { id: question } }.to change(user.subscriptions, :count).by(-1)
      end

      it 'does not change the number of subscribers if the user is not subscribed to question' do
        expect { delete :unsubscribe, params: { id: another_question } }.to_not change(user.subscriptions, :count)
      end
    end
  end
end
