require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:best_answer).class_name('Answer').optional(:true) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
