# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def status_values
    ['lost','25%','50%','75%','90%','100%']
  end

  def users_for_select
    User.all.map{|u| [u.name]}.insert(0, ['Select a user', ''])
  end
  
  def people_for_select
    Person.cached.map{|p| [p.name]}.insert(0, ['Select a person', ''])
  end
  
  def companies_for_select
    Company.cached.map{|c| [c.name]}.insert(0, ['Select a company', ''])
  end
  
  def status_for_select
    status_values.map{|val| [val, val]}
  end
  
  def paginate_resource(options = {})
    collection = options[:collection] || instance_variable_get("@#{controller_name}")
    total = options[:total] || collection.size
    page, per_page = instance_variable_get("@page"), instance_variable_get("@per_page")
    result = ""
    if page && page > 1
      result += link_to "#{image_tag("arrowl.png", :alt => "Previous Page")}" "Previous Page", url_for(:controller => controller_name, :page => page - 1), :class => "button"
    end
    if total == per_page
      result += link_to "#{image_tag("arrowr.png", :alt => "Next Page")}" "Next Page", url_for(:controller => controller_name, :page => page + 1), :class => "button" 
    end
    result
  end
  
end
