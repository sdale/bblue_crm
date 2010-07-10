module LocationSupport
  def self.included(base)
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    @name = base.clean_name
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    def locations
      self.get('locations')     
    end
    
    def location label
      raise Error, "Location label not specified.  Usage:  #{@name.downcase}.location('label_name')" unless label
      self.get('locations', :label => label)             
    end
  end
end