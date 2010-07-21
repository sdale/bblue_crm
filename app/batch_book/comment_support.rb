module CommentSupport
  def self.included(base)
    base.extend( ClassMethods )
    base.send( :include, InstanceMethods )
    @param = "#{base.name.downcase}_id".to_sym
  end
  
  module ClassMethods
  end
  
  module InstanceMethods  
    def comments(scope = :all)
      Comment.find(scope, :params => {@param => self.id})
    end
    
    def comment(id)
      comments(id)
    end
  end
end