class Deal < Base
  include TagSupport, CommentSupport, SuperTagSupport
  
  def name
    self.title
  end
  
  def amount
    super.gsub(',','')
  end

  def expected
    case self.status
      when 'lost'
        0
      when '25%'
        self.amount.to_f * 0.25
      when '50%'
        self.amount.to_f * 0.50
      when '75%'
        self.amount.to_f * 0.75
      when '90%'
        self.amount.to_f * 0.90
      when '100%'
        self.amount
    end
  end
  
  def contacts
    Person.find(:all, :params => {:deal_id => self.id})
  end
  
  def add_related_contact(contact_id)
    raise Error, "Contact not specified.  Usage: deal.add_contact(50)" unless contact_id
    self.put(:add_related_contact, :contact_id => contact_id)
  end
  
  def remove_related_contact(contact_id)
    raise Error, "Contact not specified.  Usage: deal.add_contact(50)" unless contact_id
    self.delete(:remove_related_contact, :contact_id => contact_id)
  end
end