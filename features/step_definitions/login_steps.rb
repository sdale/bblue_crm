Given /^I am logged in as "([^\"]*)" with the "([^\"]*)" password$/ do |login, password|
  user = User.find_by_login( login )
  if user
    user.password = password
    user.password_confirmation = password
    user.save!
  else
    Factory(:user, :login => login, :email => 'admin@admin.com', :password => password, :name => 'Administrator')
  end
  Given 'I am on the login page'
  When "I fill in \"login\" with \"#{login}\""
  When "I fill in \"password\" with \"#{password}\""
  When 'I press "Login"'
end