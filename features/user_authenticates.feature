Feature: User authenticates
  In order for users to sign up, sign in, & sign out
  A visitor/user
  Should be able to sign up/in/out

  Background:
    Given I am on the homepage

  Scenario: User registers, signs in, signs out
    When I join as "jane@example.com/sekret"
    Then I should see "Thank you for registering!"
    When I sign in as "jane@example.com/wrong"
    Then I should see "Email and Password do not match"
    When I sign in as "jane@example.com"
    Then I should see "Hey, jane@example.com!"
    When I follow "Sign Out"
    Then I should see "Signed Out"
    And I should see "Sign In"
    But I should not see "Sign Out"

  Scenario: User registration fails
    When I join as "/"
    Then I should see "is required" within the user's email section
    Then I should see "is required" within the user's password section
