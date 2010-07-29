class BlackList
  
  attr_reader :items

  def initialize
    @items = []
  end
  
  def add(record, reason)
    item = Item.new(record)
    other = @items.find{|i| i.record == record}
    if other.nil?
      @items << item
      item.add_reason(reason)
    else
      other.add_reason(reason)
    end  
  end

end

class Item
  attr_accessor :record, :reasons
  
  def initialize(record)
    @record = record
    @reasons = []
  end
  
  def add_reason(reason)
    @reasons << reason
  end
end