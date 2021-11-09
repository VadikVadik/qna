require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:question) }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'mark_as_best' do
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, question: question, author: author) }

    it 'mark answer as best for the question' do
      answer.mark_as_best

      expect(question.best_answer_id).to eq answer.id
    end
  end

  describe 'best?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:first_answer) { create(:answer, author: user, question: question) }
    let(:second_answer) { create(:answer, author: user, question: question) }

    before { first_answer.mark_as_best }

    it 'returns true' do
      expect(first_answer).to be_best
    end

    it 'returns false' do
      expect(second_answer).to_not be_best
    end
  end
end
