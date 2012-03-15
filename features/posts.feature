Feature: Submitting news items

  To share news about startup related news in europe
  As a user
  I want to be able to submit stories

  Scenario: Submitting
    Given I am a new authenticated user
    When I click "submit"
    And I fill in "Title" with "Hackful integration tests pull request submitted"
    And I fill in "Text" with "Check out the github issues list to see the pull request"
    And I fill in "Link" with "https://github.com/8bitpal/hackful/issues"
    And I click the button "Create Post"
    Then I should see "Post was successfully created."

  Scenario: Editing
    Given I am a new authenticated user
    And I am on the page for a submitted post
    When I click "Edit"
    And I fill in "Title" with "Hackful integration tests pull request declined"
    And I fill in "Text" with "See this example of how not to submit pull requests"
    And I fill in "Link" with "https://github.com/8bitpal/hackful/pull/41"
    And I click the button "Update Post"
    Then I should see "Post was successfully updated."

  Scenario: Editing a post where the user has deleted his account
    Given I am a new authenticated user
    And I am on the page for a submitted post
    And the user has deleted his account
    When I am on the startpage
    Then I should see "[Deleted]"
