module SerializerHelpers
  def files
    object.files.map { |file| { name: file.filename.to_s, url: file.url } }
  end

  def links
    object.links.map { |link| { name: link.name, url: link.url } }
  end
end
