class ContactList
  
  attr_reader :items

  def initialize(tags_required)
    @items = []
    @tags_required = tags_required
  end
  
  def add(record, supertags = nil)
    item = Contact.new(record, supertags)
    other = self.find(record)
    if other.nil?
      @items << item
    else
      other.supertags = supertags
    end  
  end
  
  def find(record)
    @items.find{|i| i.record == record}
  end
  
  def assign_values
    @items.each do |item|
      attr = item.record.attributes['tags']
      tags = attr.blank? ? [] : attr.attributes['tag'].to_a.map{|tag|tag.name.to_s}
      @tags_required.each do |tag_required|
        if tags.include?(tag_required)
          puts "#{item.record.name} has the #{tag_required} tag."
          item.send("#{tag_required}=", true)
        end
      end
      supertags = item.supertags
      unless supertags.blank?
        ownership = supertags.find{|e| e['name'] == 'ownership'}
        source = supertags.find{|e| e['name'] == 'source'}
        unless ownership.blank?
          item.ownership = ownership['fields']['owner'] 
          puts "#{item.record.name} ownership value: #{item.ownership || 'unassigned'}"
        end
        unless source.blank?
          item.source = source['fields']['source'] 
          puts "#{item.record.name} source value: #{item.source || 'unassigned'}"
        end
        item.has_source = true unless source.nil?
      end
    end
  end

end

class Contact
  attr_accessor :record, :ownership, :source, :has_source, :lead, :customer, :supertags
  
  def initialize(record, supertags)
    @record = record
    @ownership = nil
    @lead = nil
    @customer = nil
    @source = nil
    @has_source = nil
    @supertags = supertags
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