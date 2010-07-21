module ExtraSupport
  def self.included(base)
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    @param = "#{base.name.downcase}_id".to_sym
  end
  
  module ClassMethods
  end
  
  module InstanceMethods      
    def affiliations
      Affiliation.find(:all, :params => {@param => self.id})      
    end
    
    def communications
      Communication.find(:all, :params => {@param => self.id})
    end
    
    def todos
      Todo.find(:all, :params => {@param => self.id})
    end
  end
end