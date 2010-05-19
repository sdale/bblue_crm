# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def people_for_select
    BatchBook::Person.find(:all).map{ |p| [p.name]}.insert(0, ['Select a person', ''])
  end

  def companies_for_select
    BatchBook::Company.find(:all).map{ |c| [c.name]}.insert(0, ['Select a company','' ])
  end

  def status_for_select
    [['25%'],['50%'], ['75%'], ['90%'], ['100%'], ['Lost','lost']]
  end
end
