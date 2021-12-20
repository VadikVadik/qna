class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files, :links
  has_many :answers
  has_many :comments
  belongs_to :author

  def short_title
    object.title.truncate(7)
  end

  def files
    files_arr = []
    object.files.each { |file| files_arr << { 'name' => file.filename.to_s, 'url' => file.url } }
    files_arr
  end

  def links
    links_arr = []
    object.links.each { |link| links_arr<< { 'name' => link.name, 'url' => link.url } }
    links_arr
  end
end
