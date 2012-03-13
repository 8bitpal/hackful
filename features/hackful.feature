Feature: User authentication

  As a user
  To submit, vote and post news items
  I want to be able to sign in

  Scenario: Sign up
    Given I am on the startpage
    When I click "Sign in"
    And I click "Sign up"
    And I fill in my user details
    Then I should see "Signed up"


