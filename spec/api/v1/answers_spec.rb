require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { api_v1_question_answers_path(create(:question, author: create(:user))) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, author: user) }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before do
        get api_v1_question_answers_url(question), params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.author_id
      end

      it 'contains question object' do
        expect(answer_response['question']['id']).to eq answer.question_id
      end
    end
  end
end
