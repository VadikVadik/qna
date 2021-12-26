class AnswerSerializer < ActiveModel::Serializer
  include SerializerHelpers

  attributes :id, :body, :created_at, :updated_at, :files, :links
  has_many :comments
  belongs_to :question
  belongs_to :author
end
