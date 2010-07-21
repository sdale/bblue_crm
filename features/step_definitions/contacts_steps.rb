Given /^there are a few contacts registered$/ do
  Dupe.stub 2, :humans
  Dupe.stub 2, :companies
end

Given /^there are a few people registered$/ do
  Dupe.stub 2, :humans
end

Given /^there are a few companies registered$/ do
  Dupe.stub 2, :companies
end

Then /^I should see all pre-registered contacts$/ do
    Dupe.find(:humans).each do |person|
      Then %{I should see "#{person.first_name} #{person.last_name}"}
    end
  
    Dupe.find(:companies).each do |company|
      Then %{I should see "#{company.name}"}
    end
end