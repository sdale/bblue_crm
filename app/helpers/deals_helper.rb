module DealsHelper

  def deal_with(deal, people)
    chosen = people.find{|person| person.name == deal.deal_with}
    result = "#{deal.deal_with}"
    unless chosen.blank?
      result+= chosen.company.blank? ? "" : "(#{chosen.company})"
    else
      result
    end
  end
  
end
