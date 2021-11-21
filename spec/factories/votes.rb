FactoryBot.define do
  factory :vote do
    status { "none" }
    votable { nil }
    user { nil }
  end
end
