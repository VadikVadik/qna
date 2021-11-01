FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    # after :create do |question|
    #   create_list :answer, 3, question: question   # has_many
    # end

    trait :invalid do
      title { nil }
    end
  end
end
