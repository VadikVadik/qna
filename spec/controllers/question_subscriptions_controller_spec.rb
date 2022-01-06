require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'add new subscriber to question' do
        expect { post :create, params: { question_id: question.id } }.to change(QuestionSubscription, :count).by(1)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let!(:subscription) { create(:question_subscription, user: user, question: question) }
    let!(:other_subscription) { create(:question_subscription, user: author, question: question) }

    before do
      login(user)
    end

    context 'with valid attributes' do
      it 'delete subscriber from question' do
        expect { delete :destroy, params: { id: subscription } }.to change(user.subscriptions, :count).by(-1)
      end

      it 'does not change the number of subscribers if the user is not subscribed to question' do
        expect { delete :destroy, params: { id: subscription } }.to_not change(author.subscriptions, :count)
      end
    end
  end
end
