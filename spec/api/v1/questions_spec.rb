require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:method) { :get }
      let(:api_path) { api_v1_question_url(question) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, author: user) }
      let(:question_response) { json['question'] }

      before do
        get api_v1_question_url(question), params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question' do
        expect(json.first[0]).to eq 'question'
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        post '/api/v1/questions', params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
      end

      it 'returns question' do
        expect(json.first[0]).to eq 'question'
      end

      context 'vith valid attributes' do
        it 'save new question in the database' do
          expect { post api_v1_questions_url, params: { access_token: access_token.token,
                                              question: attributes_for(:question) },
                                              headers: headers }.to change(Question, :count).by(1)
        end
      end

      context 'vith invalid attributes' do
        it 'does not save the question' do
          expect { post api_v1_questions_url, params: { access_token: access_token.token,
                                              question: attributes_for(:question, :invalid) },
                                              headers: headers }.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:method) { :patch }
      let(:api_path) { api_v1_question_url(question) }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      it 'changes question attributes' do
        patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token,
                                                            id: question,
                                                            question: { title: "New title", body: "New body" },
                                                            headers: headers }
        question.reload

        expect(question.title).to eq "New title"
        expect(question.body).to eq "New body"
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:question) { create(:question, author: create(:user)) }
      let(:method) { :delete }
      let(:api_path) { api_v1_question_url(question) }
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, author: user) }
      let!(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      it 'deletes the created question' do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers
        expect(json[:messsage]).to eq 'Question was successfully deleted'
      end
    end
  end
end
