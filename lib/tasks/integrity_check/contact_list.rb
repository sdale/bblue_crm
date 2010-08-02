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
  
  def assign_tags
    @items.each do |item|
      attr = item.record.attributes['tags']
      tags = attr.blank? ? [] : attr.attributes['tag'].to_a.map{|tag|tag.name.to_s}
      if tags.include?('customer')
        puts "#{item.record.name} is a customer."
        item.customer = true 
      end
      if tags.include?('lead')
        puts "#{item.record.name} is a lead."
        item.lead = true 
      end
    end
  end

end

class Contact
  attr_accessor :record, :ownership, :source, :has_source, :lead, :customer
  
  def initialize(record)
    @record = record
    @ownership = nil
    @lead = nil
    @customer = nil
    @source = nil
    @has_source = nil
  end
  
  def lead?
    !@lead.blank?
  end
  
  def customer?
    !@customer.blank?
  end
  
  def source?
    !@source.blank?
  end
  
  def has_source?
    !@has_source.blank?
  end
end