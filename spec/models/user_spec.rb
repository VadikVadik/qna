require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:question_subscriptions).dependent(:destroy) }
  it { should have_many(:subscriptions).through(:question_subscriptions).source(:question) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author_of?' do
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
