Feature: User authenticates
  In order for a user to gain value from the system
  A user
  Should be able to view daily reports for a listing

  Scenario: User views their reports
    Given I am logged in
    And airbnb returns the following similar listings for page 1 for listing 12345
      | name             | bedrooms | beds | bathrooms | person_capacity | min_nights |
      | My Awesome Apt   | 1        | 1    | 1         | 2               | 1          |
      | My Awesome House | 2        | 1    | 1         | 2               | 1          |
      | My Awesome Condo | 1        | 1    | 1         | 2               | 1          |
      | My Awesome Barn  | 3        | 1    | 1         | 2               | 1          |
      | My Awesome Boat  | 2        | 1    | 1         | 2               | 1          |
    And airbnb returns the following for listing 12345
      | name                     | city     | state | zipcode | country_code | neighborhood | address         | lat   | lng   | bedrooms | beds | person_capacity |
      | 1 Bedroom in Fort Greene | Brooklyn | NY    | 11205   | US           | Fort Greene  | 131 Classon Ave | 75.43 | 75.42 | 2        | 2    | 4               |
    And I have the following listing:
      | airbnb_id |
      | 12345     |
    And the nightly report job ran
    When I am on the homepage
    And I follow "Listings"
    And I follow "1 Bedroom in Fort Greene"
    Then I should see "Reports"
    When I follow "Latest"
    Then I should see "2"
