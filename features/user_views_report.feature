Feature: User authenticates
  In order for a user to gain value from the system
  A user
  Should be able to view daily reports for a listing

  Background:
    Given I am logged in
    And I have the following listing:
      | name                     | airbnb_id |
      | 1 Bedroom in Fort Greene | 12345     |
    And airbnb returns the following similar listings for page 1 for listing 12345
      | name           | address          | city     | state | zipcode | country_code | smart_location | neighborhood | latitude | longitude | bedrooms | beds | bathrooms | person_capacity | min_nights |
      | My Awesome Apt | 150 Clermont Ave | Brooklyn | NY    | 11205   | US           | Brooklyn, NY   | Fort Greene  | 72.34    | 72.30     | 1        | 1    | 1         | 2               | 1          |
    And airbnb returns the following similar listings for page 2 for listing 12345
      | name             | address          | city     | state | zipcode | country_code | smart_location | neighborhood | latitude | longitude | bedrooms | beds | bathrooms | person_capacity | min_nights |
      | My Awesome House | 150 Clermont Ave | Brooklyn | NY    | 11205   | US           | Brooklyn, NY   | Fort Greene  | 72.34    | 72.30     | 1        | 1    | 1         | 2               | 1          |
    And airbnb returns the following similar listings for page 3 for listing 12345
      | name             | address          | city     | state | zipcode | country_code | smart_location | neighborhood | latitude | longitude | bedrooms | beds | bathrooms | person_capacity | min_nights |
      | My Awesome Condo | 150 Clermont Ave | Brooklyn | NY    | 11205   | US           | Brooklyn, NY   | Fort Greene  | 72.34    | 72.30     | 1        | 1    | 1         | 2               | 1          |
    And airbnb returns the following similar listings for page 4 for listing 12345
      | name            | address          | city     | state | zipcode | country_code | smart_location | neighborhood | latitude | longitude | bedrooms | beds | bathrooms | person_capacity | min_nights |
      | My Awesome Barn | 150 Clermont Ave | Brooklyn | NY    | 11205   | US           | Brooklyn, NY   | Fort Greene  | 72.34    | 72.30     | 1        | 1    | 1         | 2               | 1          |
    And airbnb returns the following similar listings for page 5 for listing 12345
      | name            | address          | city     | state | zipcode | country_code | smart_location | neighborhood | latitude | longitude | bedrooms | beds | bathrooms | person_capacity | min_nights |
      | My Awesome Boat | 150 Clermont Ave | Brooklyn | NY    | 11205   | US           | Brooklyn, NY   | Fort Greene  | 72.34    | 72.30     | 1        | 1    | 1         | 2               | 1          |

  Scenario: User views their reports
    When I am on the homepage
    And I follow "Listings"
    And I follow "1 Bedroom in Fort Greene"
    Then I should see "Reports"
