require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let(:author) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: author) }

    it 'returns true' do
      expect(author).to be_author_of(question)
    end

    it 'returns false' do
      expect(another_user).to_not be_author_of(question)
    end
  end
end
