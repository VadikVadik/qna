require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:created_questions).class_name('Question').dependent(:destroy) }
  it { should have_many(:created_answers).class_name('Answer').dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'to confirm the authorship of the resource' do
    let(:author) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: author) }

    it 'determines that the user is the author' do
      expect(author.is_author?(question)).to eq true
    end

    it 'determines that the user is not the author' do
      expect(another_user.is_author?(question)).to eq false
    end
  end
end
