module SuperTagSupport
  def self.included(base)
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    @name = base.clean_name
  end
  
  module ClassMethods
    def find_all_by_supertag(supertag, cached = true, &block)
      array = []
      all = cached ? self.cached('eager') : self.find(:all)
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
    
    def add_supertag(name, params = {})
      raise Error, "Tag name not specified.  Usage:  obs.add_supertag('tag_name')" unless name
      self.put(:add_tag, :tag => name)
      unless params.empty?
        self.put("super_tags/#{name.gsub(/ /, '_')}", :super_tag => params)
      end
    end
  end
end

      
      
