require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('https://google.com', 'http://google.com').for(:url) }
  it { should_not allow_value('google.com', 'htps:google.com').for(:url) }

  describe 'gist?' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:link) { create(:link, url: 'https://gist.github.com/VadikVadik/f72820f93dadf603ec4820c32ca28ddf', linkable: question) }
    let(:another_link) { create(:link, linkable: question) }

    it 'returns true' do
      expect(link).to be_gist
    end

    it 'returns false' do
      expect(another_link).to_not be_gist
    end
  end
end
