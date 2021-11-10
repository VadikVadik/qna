class Award < ApplicationRecord
  belongs_to :question
  belongs_to :owner, class_name: 'User', optional: true

  has_one_attached :image

  validates :title, presence: true
end
