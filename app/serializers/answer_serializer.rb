class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :files, :links
  has_many :comments
  belongs_to :question
  belongs_to :author

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
