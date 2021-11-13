class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: /https?:\/\/[\S]+/, message: 'invalid' }

  scope :gists, -> { where(gist: true) }
  scope :not_gists, -> { where(gist: false) }

  def gist?
    URI::parse(url).host == "gist.github.com"
  end
end
