class ContactList
  
  attr_reader :items

  def initialize
    @items = []
  end
  
  def add(record)
    item = Contact.new(record)
    other = self.find(record)
    if other.nil?
      @items << item
      item
    else
      other
    end  
  end
  
  def find(record)
    @items.find{|i| i.record == record}
  end

end

class Contact
  attr_accessor :record, :tags, :ownership, :source, :has_source
  
  def initialize(record)
    @record = record
    @ownership = nil
    @tags = nil
    @source = nil
    @has_source = nil
  end
  
  def tags?
    !@tags.blank?
  end
  
  def source?
    !@source.blank?
  end
  
  def has_source?
    !@has_source.blank?
  end
end