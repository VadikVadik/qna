class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: /https?:\/\/[\S]+/, message: 'invalid' }

  def self.get_gists(resource)
    resource.links.select { |link| link.gist? }
  end

  def gist?
    URI::parse(url).host == "gist.github.com"
  end
end
