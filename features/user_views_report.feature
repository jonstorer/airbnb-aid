Feature: User authenticates
  In order for a user to gain value from the system
  A user
  Should be able to view daily reports for a listing

  Background:
    Given I am logged in
    And I have the following listing:
      | name                     | city     | state |
      | 1 Bedroom in Fort Greene | Brooklyn | NY    |

  Scenario: User adds a listing
    When I am on the homepage
    And I follow "Listings"
    And I follow "1 Bedroom in Fort Greene"
    Then I should see "Reports"
