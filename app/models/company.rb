class Company < Base
  include TagSupport, LocationSupport, SuperTagSupport, CommentSupport, ExtraSupport
  
  def type
    'company'
  end    
  
  def people
    self.get(:people)      
  end
end