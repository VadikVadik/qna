require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:other_answer) { create(:answer, question: other_question, author: other) }
    let(:comment) { create(:comment, commentable: question, author: user) }
    let(:other_comment) { create(:comment, commentable: other_question, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create_comment, Question }
    it { should be_able_to :create_comment, Answer }
    it { should be_able_to :vote, Question }
    it { should be_able_to :vote, Answer }
    it { should be_able_to :unvote, Question }
    it { should be_able_to :unvote, Answer }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }
    it { should be_able_to :update, comment }
    it { should_not be_able_to :update, other_comment }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should be_able_to :destroy, comment }
    it { should_not be_able_to :destroy, other_comment }
  end
end
