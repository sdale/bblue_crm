class Person < Base
  include TagSupport, LocationSupport, SuperTagSupport, CommentSupport, ExtraSupport

  def type
    'person'
  end

  def name
    unless self.first_name.blank? && self.last_name.blank?
      "#{self.first_name} #{self.last_name}"
    else
      ''
    end
  end 
  
  #add_location only supported on Person, check bottom of the file for a list of params.
  def add_location(params = {})
    params.update(:label => 'home') unless params[:label].present?
    self.post(:locations, :location => params)
  end

  protected
  
  def validate
    errors.add("First Name", "can't be blank.") if self.first_name.blank?
    errors.add("Last Name", "can't be blank.") if self.last_name.blank?
  end
end