Feature: Contact management
  In order to manage contacts
  a user
  wants to be able to list, create, update and destroy contacts
  
  Background:
  	Given I am logged in as "admin" with the "123456" password
  
  Scenario: Listing contacts
  	Given there are a few contacts registered
  		And I go to the contacts page
  	Then I should see all pre-registered contacts
  	
  Scenario: Creating a person
  	Given I am on the contacts page
  		And I follow "New Person"
  		And I fill in "First Name" with "Test"
  		And I fill in "Last Name" with "Another Test"
  		And I press "Save"
  	Then I should see "Person successfully created!"
  		And I should be on the contacts page
  		
  Scenario: Creating a company
  	Given I am on the contacts page
  		And I follow "New Company"
  		And I fill in "Name" with "Test"
  		And I press "Save"
  	Then I should see "Company successfully created!"
  		And I should be on the contacts page
  
  Scenario: Updating a person
  	Given there are a few people registered
  		And I go to some person's page
  		And I follow "Edit"
  		And I fill in "First Name" with "Test Changing"
  		And I press "Save"
  	Then I should see "Person successfully updated!"
  		And I should be on the contacts page	
  		
  Scenario: Updating a company
  	Given there are a few companies registered
  		And I go to some company's page
  		And I follow "Edit"
  		And I fill in "Name" with "Test Changing"
  		And I press "Save"
  	Then I should see "Company successfully updated!"
  		And I should be on the contacts page	
  		
  Scenario: Destroying a person
  	Given there are a few people registered
  		And I go to some person's page
  		And I follow "Delete"
  	Then I should see "Contact successfully deleted!"
  		And I should be on the contacts page
  
  Scenario: Destroying a company
  	Given there are a few companies registered
  		And I go to some company's page
  		And I follow "Delete"
  	Then I should see "Contact successfully deleted!"
  		And I should be on the contacts page
    
  