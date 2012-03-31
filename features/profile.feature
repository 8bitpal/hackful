Feature: Updating user profile

  To share information about me or update my settings
  As a user
  I want to be able to update my settings

  Scenario: Changing user-name
    Given I am a new authenticated user
    When I visit "/users/edit"
    And I fill in my user details without submitting
    And I fill in "User Name" with "newtestname"
    And I click the button "Update"
    Then I should see "You updated your account successfully."

  Scenario: Changing password
    Given I am a new authenticated user
    When I visit "/users/edit"
    And I fill in my user details without submitting
    And I fill in "Password" with "newtestpassword"
    And I fill in "Password confirmation" with "newtestpassword"
    And I click the button "Update"
    Then I should see "You updated your account successfully."

  Scenario: Deleting account
    Given I am a new authenticated user
    When I visit "/users/edit"
    And I click "Cancel my account"
    Then I should see "Bye! Your account was successfully cancelled. We hope to see you again soon."
