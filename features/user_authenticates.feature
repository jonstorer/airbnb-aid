Feature: User authenticates
  In order for users to sign up, sign in, & sign out
  A visitor/user
  Should be able to sign up/in/out

  Background:
    Given I am registered on Airbnb as:
      | airbnb_user_id | first_name |
      | 1234           | Jane       |

  Scenario: User registers
    Given I am on the homepage
    And I follow "Join"
    And I join as "jane@example.com/1234/sekret"
    Then I should see "Thank you for registering! We're updating your account from Airbnb."
    When I sign in as "jane@example.com"
    Then I should see "Hey, Jane!"
