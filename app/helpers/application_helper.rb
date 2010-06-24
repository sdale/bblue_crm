# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def users_for_select
    User.all.map{|u| [u.name]}.insert(0, ['Select a user', ''])
  end

  def people_for_select
    BatchBook::Person.find(:all).map{ |p| [p.name]}.insert(0, ['Select a person', ''])
  end
  

  def companies_for_select
    BatchBook::Company.find(:all).map{ |c| [c.name]}.insert(0, ['Select a company','' ])
  end
  
  def contacts_for_select
    contacts = BatchBook::Person.find(:all) | BatchBook::Company.find(:all)
    contacts.sort! { |x, y| x.attributes['id'] <=> y.attributes['id']  }
    contacts.map{ |c| [c.name]}.insert(0, ['Select a contact','' ])
  end

  def status_values
    ['lost','25%','50%','75%','90%','100%']
  end
  
  def status_for_select
    status_values.map{|val| [val, val]}
  end
  
end
