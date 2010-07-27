Given /^I am logged in as "([^\"]*)" with the "([^\"]*)" password$/ do |email, password|
  user = User.find_by_email( email )
  if user
    user.password = password
    user.password_confirmation = password
    user.save!
  else
    Factory(:user, :email => 'default@default.com', :password => password, :name => 'Default')
  end
  Given 'I am on the login page'
  When "I fill in \"email\" with \"#{email}\""
  When "I fill in \"password\" with \"#{password}\""
  When 'I press "Login"'
end