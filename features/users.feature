Feature: Users management
  In order to manage the users
  a user
  wants to be able to CRUD users
  
  Background:
  	Given I am on the users page
  		And I am logged in as "default@default.com" with the "123456" password
  
  Scenario: Listing users
    Given I am on the users page
    Then I should see "All Users"
    
  Scenario: Creating a valid user
  	Given I follow "New"
  		And I fill in "Name" with "test"
  		And I fill in "Email" with "test@test.com"
  		And I fill in "Password" with "1234"
  		And I fill in "Password Confirmation" with "1234"
  	When I press "Save"
  		Then I should see "Registration was successful!"
  			And I should be on the users page
  			And I should not see "Logged in as test"
  
  Scenario: Creating an invalid user, same e-mail
   	Given I follow "New"
		And I fill in "Name" with "Default"
		And I fill in "Email" with "default@default.com"
		And I fill in "Password" with "1234"
		And I fill in "Password Confirmation" with "1234"
  	When I press "Save"
  		Then I should see "Email has already been taken"
  		
  Scenario: Destroying a user
   	Given I follow "Delete"
   	Then I should see "You need to login first!"
 		And I should be on the login users page
  
    
  