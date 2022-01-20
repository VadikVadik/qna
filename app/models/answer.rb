class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question, touch: true
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  after_create :send_creation_message

  def mark_as_best
		question.update(best_answer_id: self.id)
	end

  def best?
    question.best_answer == self
  end

  def send_creation_message
    AnswersMailer.created_answer(self).deliver_later
  end
end
