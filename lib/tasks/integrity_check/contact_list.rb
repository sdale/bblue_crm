class ContactList
  
  attr_reader :items

  def initialize
    @items = []
  end
  
  def add(record)
    item = Contact.new(record)
    other = @items.find{|i| i.record == record}
    if other.nil?
      @items << item
      item
    else
      other
    end  
  end

end

class Contact
  attr_accessor :record, :tags, :ownership, :source
  
  def initialize(record)
    @record = record
    @ownership = nil
    @tags = nil
    @source = nil
  end
  
  def tags?
    !@tags.blank?
  end
  
  def source?
    !@source.blank?
  end
end