def view_deals(deals)
  deals.each do |deal|
    Then %{I should see "#{deal.title}"}
      And %{I should see "#{deal.assigned_to}"}
      And %{I should see "#{deal.amount}"}
  end
end

def selected_users
  User.all[0..2]
end

def selected_statuses
  ['lost', '100']
end

Given /^there are a few deals registered$/ do
  Dupe.stub 15, :deals
end

Then /^I should see all pre-registered deals$/ do
    view_deals(Dupe.find(:deals))
end

When /^I check some user's name$/ do
  user = User.first
  When %{I check "#{user.name.parameterize}"}
end

Then /^I should see results filtered by that user$/ do
  user = User.first
  view_deals(Dupe.find(:deals) {|d| d.assigned_to == user.name})
end

When /^I check a few users' name$/ do
  users = User.all
  selected_users.each do |user|
    When %{I check "#{user.name.parameterize}"}
  end
end

Then /^I should see results filtered by those users$/ do
  deals = []
  selected_users.each do |user|
    deals << Dupe.find(:deals) {|d| d.assigned_to == user.name}
  end
  view_deals(deals.flatten)
end

When /^I check a few status options$/ do
  selected_statuses.each do |status|
    When %{I check "#{status}"}
  end
end

Then /^I should see results filtered by their status$/ do
  deals = []
  selected_statuses.each do |status|
    deals << Dupe.find(:deals) {|d| d.status == status}
  end
  view_deals(deals.flatten)
end