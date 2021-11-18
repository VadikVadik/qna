class Answer < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  def mark_as_best
		question.update(best_answer_id: self.id)
	end

  def best?
    question.best_answer == self
  end
end
