Given /^there are a few users registered$/ do
  5.times {Factory(:user)}
end

Then /^I should see all pre-registered users$/ do
  User.find(:all).each do |user|
    Then %{I should see "#{user.name}"}
  end
end