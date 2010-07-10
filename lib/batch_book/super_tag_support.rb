module SuperTagSupport
  def self.included(base)
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    @name = base.clean_name
  end
  
  module ClassMethods
    def find_all_by_supertag(supertag, &block)
      array = []
      all = self.find(:all)
      all.each do |one|
        supertags = one.supertags
        next if supertags.blank?
        temp = supertags.find{|e| e['name'] == supertag}
        array << one unless temp.blank? || temp['fields'].blank?
      end
      block_given? ? array.find_all(&block) :  array
    end
  end
  
  module InstanceMethods
    def supertags   
      self.get('super_tags')
    end
  
    def supertag name
      raise Error, "SuperTag name not specified.  Usage:  #{@name.downcase}.supertag('tag_name')" unless name
      self.get('super_tags', :name => name)    
    end
  
    def add_supertag(name)
      self.add_tag(name)
    end
  end
end

      
      
