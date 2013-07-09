Feature: User authenticates
  In order for users to sign up, sign in, & sign out
  A visitor/user
  Should be able to sign up/in/out

  Background:
    Given I am registered on Airbnb as:
      | airbnb_user_id | first_name |
      | 1234           | Jane       |
    And I am on the homepage

  Scenario: User registers
    When I join as "jane@example.com/1234/sekret"
    Then I should see "Thank you for registering! We're updating your account from Airbnb."
    When I sign in as "jane@example.com"
    Then I should see "Hey, Jane!"

  Scenario: User registration fails
    When I join as "//"
    Then I should see "is required" within the user's airbnb user id section
    Then I should see "is required" within the user's email section
    Then I should see "is required" within the user's password section
