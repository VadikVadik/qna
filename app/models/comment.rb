class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true
end
