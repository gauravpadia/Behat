Feature: Names
  In order to run only needed features
  As a Behat user
  I need to Behat support features & scenario/outline names filtering

  Background:
    Given a file named "features/support/bootstrap.php" with:
      """
      <?php
      require_once 'PHPUnit/Autoload.php';
      require_once 'PHPUnit/Framework/Assert/Functions.php';
      """
    And a file named "features/support/FeaturesContext.php" with:
      """
      <?php

      use Behat\Behat\Context\BehatContext, Behat\Behat\Exception\Pending;
      use Behat\Gherkin\Node\PyStringNode,  Behat\Gherkin\Node\TableNode;

      class FeaturesContext extends BehatContext
      {
          /**
           * @Given /^Some slow step N(\d+)$/
           */
          public function someSlowStepN($num) {}

          /**
           * @Given /^Some normal step N(\d+)$/
           */
          public function someNormalStepN($num) {}

          /**
           * @Given /^Some fast step N(\d+)$/
           */
          public function someFastStepN($num) {}
      }
    """
    And a file named "features/feature1.feature" with:
      """
      Feature: First Feature

        Background:
          Given Some slow step N11

        Scenario: First Scenario
          Given Some slow step N12
          And Some normal step N13

        Scenario: Second Scenario
          Given Some fast step N14
      """
    And a file named "features/feature2.feature" with:
      """
      Feature: Second Feature

        Background:
          Given Some normal step N21

        Scenario: First Scenario
          Given Some slow step N22
          And Some fast step N23
      """

  Scenario: First Name
    When I run "behat -f pretty --name First"
    Then it should pass with:
      """
      Feature: First Feature
      
        Background:                # features/feature1.feature:3
          Given Some slow step N11 # FeaturesContext::someSlowStepN()
      
        Scenario: First Scenario   # features/feature1.feature:6
          Given Some slow step N12 # FeaturesContext::someSlowStepN()
          And Some normal step N13 # FeaturesContext::someNormalStepN()
      
        Scenario: Second Scenario  # features/feature1.feature:10
          Given Some fast step N14 # FeaturesContext::someFastStepN()
      
      Feature: Second Feature
      
        Background:                  # features/feature2.feature:3
          Given Some normal step N21 # FeaturesContext::someNormalStepN()
      
        Scenario: First Scenario     # features/feature2.feature:6
          Given Some slow step N22   # FeaturesContext::someSlowStepN()
          And Some fast step N23     # FeaturesContext::someFastStepN()
      
      3 scenarios (3 passed)
      8 steps (8 passed)
      """

  Scenario: Second Name
    When I run "behat -f pretty --name 'Second Scenario'"
    Then it should pass with:
      """
      Feature: First Feature
      
        Background:                # features/feature1.feature:3
          Given Some slow step N11 # FeaturesContext::someSlowStepN()
      
        Scenario: Second Scenario  # features/feature1.feature:10
          Given Some fast step N14 # FeaturesContext::someFastStepN()
      
      1 scenario (1 passed)
      2 steps (2 passed)
      """

  Scenario: RegEx
    When I run "behat -f pretty --name '/nd Scenario$/'"
    Then it should pass with:
      """
      Feature: First Feature
      
        Background:                # features/feature1.feature:3
          Given Some slow step N11 # FeaturesContext::someSlowStepN()
      
        Scenario: Second Scenario  # features/feature1.feature:10
          Given Some fast step N14 # FeaturesContext::someFastStepN()
      
      1 scenario (1 passed)
      2 steps (2 passed)
      """
