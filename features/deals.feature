Feature: Deals reports
  In order to create deals reports
  a user
  wants to be able to list and filter deals by who they're assigned to
  
  Background:
  	Given I am logged in as "default@default.com" with the "123456" password
  		And there are a few users registered
  		And there are a few deals registered
  
  Scenario: Listing deals
  	Given I am on the deals page
  	Then I should see all pre-registered deals
  		And I should see all pre-registered users
  		
  Scenario: Filtering by a single user
  	Given I am on the deals page
  	When I check some user's name
  		And I press "Filter"
  	Then I should see results filtered by that user
  	
  Scenario: Filtering by multiple users
  	Given I am on the deals page
  	When I check a few users' name
  		And I press "Filter"
  	Then I should see results filtered by those users
  	
 Scenario: Searching by status
  	Given I am on the deals page
  	When I check a few status options
  		And I press "Filter"
  	Then I should see results filtered by their status
  
  Scenario: Creating a deal
  	Given I am on the deals page
  		And I follow "New"
  		And I fill in "Title" with "Test"
  		And I fill in "Amount" with "100"
  		And I press "Save"
  	Then I should see "Deal successfully created!"
  		And I should be on the deals page
  		
  Scenario: Updating a deal
  	Given there are a few deals registered
  		And I go to some deal's page
  		And I follow "Edit"
  		And I fill in "Title" with "Test Changing"
  		And I press "Save"
  	Then I should see "Deal successfully updated!"
  		And I should be on the deals page	
  		
  Scenario: Destroying a deal
  	Given there are a few deals registered
  		And I go to some deal's page
  		And I follow "Delete"
  	Then I should see "Deal successfully removed!"
  		And I should be on the deals page
  