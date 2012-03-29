Feature: User authentication

  As a user
  To submit, vote and post news items
  I want to be able to sign in

  Scenario: Sign up
    #Issue :
    #Given I am not authenticated
    Given I am on the startpage
    When I click "Sign in"
    And I click "Sign up"
    And I fill in new user details
    Then I should see "Welcome! You have signed up successfully."

  Scenario: Sign in
    Given I am a new authenticated user
    Then I should see "Signed in"

  #Issue : 
  #Scenario: Sign out
  #  Given I am a new authenticated user
  #  When I click "Sign out"
  #  Then I should see "Signed out successfully."

  Scenario: Sign out
    Given I am a new authenticated user
    When I click "Sign out"
    Then I should see "Signed out successfully."
    
