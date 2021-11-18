class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type],
                                    message: 'your vote has already been counted' }

  scope :for, -> { where(status: 'for') }
  scope :against, -> { where(status: 'against') }
end
