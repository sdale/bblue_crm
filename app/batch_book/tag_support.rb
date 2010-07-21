module TagSupport
  def self.included(base)
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    @name = base.name
    @param = if @name == 'Person' || @name == 'Company'
      :contact_id 
    else
      "#{@name.downcase}_id".to_sym
    end
  end
  
  module ClassMethods
  end
  
  module InstanceMethods  
    def tags
      Tag.find(:all, :params => {@param => self.id})
    end  
    def add_tag(name)
      raise Error, "Tag name not specified.  Usage:  obj.add_tag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
    end
    def remove_tag(name)
      raise Error, "Tag name not specified.  Usage:  obj.remove_tag('tag_name')" unless name
      self.delete(:remove_tag, :tag => name)
    end
  end
end