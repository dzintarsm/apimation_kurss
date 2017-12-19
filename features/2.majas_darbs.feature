Feature: 2.majas_darbs feature
  Create a project>add two environments>add variables>delete environments

  Scenario: Create a project
    When I create a new project
    Then I am able to create new environments
    Then I am able to add global variables
    Then I am able to delete environments