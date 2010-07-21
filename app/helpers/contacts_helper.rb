module ContactsHelper
  
  def convertible?(contact)
    attr = contact.attributes['tags']
    return false if attr.blank?
    tags = attr.attributes.delete("tag").to_a.map{|tag|tag.name}
    tags.include?('lead') ? true : false
  end
  
end
