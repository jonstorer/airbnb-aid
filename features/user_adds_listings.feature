Feature: User authenticates
  In order for users to sign up, sign in, & sign out
  A visitor/user
  Should be able to sign up/in/out

  Background:
    Given airbnb returns the following for listing 12345
      | name                     |
      | 1 Bedroom in Fort Greene |
    Given I am logged in
    And I am on the homepage

  Scenario: User adds a listing
    When I follow "Listings"
    And I follow "Add Listing"
    And I fillin "Airbnb" with "12345"
    And I press "Add"
    Then I should see "Listing 12345"
    When jobs have run
    And I follow "Listings"
    Then I should see "1 Bedroom in Fort Greene"
    And I should not see "Listing 12345"
