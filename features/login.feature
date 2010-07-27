Feature: Login

  In order to be able to use the application
  As a user
  I want to be able to login

  Background:
    Given the following users exists:
      | name              	| email     				| password  | password_confirmation |
      | Default		 		| default@default.com		| 123456 	| 123456  	            |
      
      
  Scenario: Login required
  	Given I am on the homepage
  		Then I should see "You need to login first!"    

  Scenario: Login successfully
    Given I am on the login page
      And I fill in "email" with "default@default.com"
      And I fill in "password" with "123456"
     When I press "Login"
     Then I should see "Login successful!"
     	And I should be on the homepage
     	And I should see "Logged in as default@default.com"

  Scenario: Login failed
    Given I am on the login page
      And I fill in "email" with "default@default.com"
      And I fill in "password" with "654321"
     When I press "Login"
     Then I should see "Login unsuccessful"
     	And I should be on the login page
     	
  Scenario: Logoff
  	Given I am logged in as "default@default.com" with the "123456" password
  	When I follow "Logoff"
  	Then I should see "You have been logged out."  