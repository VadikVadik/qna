require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
end
