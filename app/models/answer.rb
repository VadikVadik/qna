class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question

  validates :body, presence: true

  def mark_as_best
		question.update(best_answer_id: self.id)
	end

  def best?
    question.best_answer == self
  end
end
