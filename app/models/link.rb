class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: /https?:\/\/[\S]+/, message: 'invalid' }

  after_create :after_create_set_gist_attribute

  scope :gists, -> { where(gist: true) }
  scope :not_gists, -> { where(gist: false) }

  def gist?
    URI::parse(url).host == "gist.github.com"
  end

  private

  def after_create_set_gist_attribute
    self.update(gist: true) if self.gist?
  end
end
