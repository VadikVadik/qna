class User < ApplicationRecord
  has_many :created_questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy
  has_many :created_answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def is_author?(resource)
    created_questions.include?(resource) || created_answers.include?(resource)
  end
end
