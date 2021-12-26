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

  describe 'GET /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:answer) { create(:answer, question: question, author: create(:user)) }
      let(:method) { :get }
      let(:api_path) { api_v1_answer_url(answer) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:answer_response) { json['answer'] }

      before do
        get api_v1_answer_url(answer), params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer' do
        expect(json.first[0]).to eq 'answer'
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.author_id
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:method) { :post }
      let(:api_path) { api_v1_question_answers_url(question) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        post api_v1_question_answers_url(question), params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
      end

      it 'returns question' do
        expect(json.first[0]).to eq 'answer'
      end

      context 'vith valid attributes' do
        it 'save new answer in the database' do
          expect { post api_v1_question_answers_url(question),
                      params: { access_token: access_token.token,
                      answer: attributes_for(:answer) },
                      headers: headers }.to change(Answer, :count).by(1)
        end
      end

      context 'vith invalid attributes' do
        it 'does not save the answer' do
          expect { post api_v1_question_answers_url(question),
                      params: { access_token: access_token.token,
                      answer: attributes_for(:answer, :invalid) },
                      headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:answer) { create(:answer, question: question, author: create(:user)) }
      let(:method) { :patch }
      let(:api_path) { api_v1_answer_url(answer) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let(:access_token) { create(:access_token) }

      it 'changes answer attributes' do
        patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token,
                                                        id: answer,
                                                        answer: { body: "New body" },
                                                        headers: headers }
        answer.reload
        expect(answer.body).to eq "New body"
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:answer) { create(:answer, question: question, author: create(:user)) }
      let(:method) { :delete }
      let(:api_path) { api_v1_question_url(answer) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, author: user) }
      let(:answer) { create(:answer, question: question, author: user) }
      let!(:access_token) { create(:access_token) }

      it 'deletes the created answer' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers
        expect(json[:messsage]).to eq 'Answer was successfully deleted'
      end
    end
  end
end
