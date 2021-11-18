require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:voter_one) { create(:user) }
  let(:voter_two) { create(:user) }

  it '#rating' do
    model_klass = model.to_s.underscore.to_sym

    if model == Question
      votable = create(model_klass, author: user)
    else
      votable = create(model_klass, author: user, question: question)
    end

    votable.votes.create(status: 'for', user: voter_one)
    votable.votes.create(status: 'for', user: voter_two)

    expect(votable.rating).to eq(2)
  end
end
