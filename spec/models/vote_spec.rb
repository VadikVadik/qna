require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  subject { question.votes.new(user: user) }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]).
       with_message('your vote has already been counted') }
end
