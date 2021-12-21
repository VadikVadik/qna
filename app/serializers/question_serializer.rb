class QuestionSerializer < ActiveModel::Serializer
  include SerializerHelpers

  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files, :links
  has_many :answers
  has_many :comments
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end
end
