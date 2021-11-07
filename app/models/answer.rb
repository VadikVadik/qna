class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best
		question.update(best_answer_id: self.id)
	end

  def best?
    question.best_answer == self
  end
end
