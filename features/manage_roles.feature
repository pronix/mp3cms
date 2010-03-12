Feature: Manage roles
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new roles
    Given I am on the new roles page
    When I fill in "Name" with "name 1"
    And I fill in "Title" with "title 1"
    And I fill in "Description" with "description 1"
    And I fill in "System" with "system 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "title 1"
    And I should see "description 1"
    And I should see "system 1"

  # Rails generates Delete links that use Javascript to pop up a confirmation
  # dialog and then do a HTTP POST request (emulated DELETE request).
  #
  # Capybara must use Culerity or Selenium2 (webdriver) when pages rely on
  # Javascript events. Only Culerity supports confirmation dialogs.
  # 
  # cucumber-rails will turn off transactions for scenarios tagged with 
  # @selenium, @culerity, @javascript or @no-txn and clean the database with 
  # DatabaseCleaner after the scenario has finished. This is to prevent data 
  # from leaking into the next scenario.
  #
  # Culerity has some performance overhead, and there are two alternatives to using
  # Culerity:
  #
  # a) You can remove the @culerity tag and run everything in-process, but then you 
  # also have to modify your views to use <button> instead: http://github.com/jnicklas/capybara/issues#issue/12
  #
  # b) Replace the @culerity tag with @emulate_rails_javascript. This will detect
  # the onclick javascript and emulate its behaviour without a real Javascript
  # interpreter.
  #
  @culerity
  Scenario: Delete roles
    Given the following roles:
      |name|title|description|system|
      |name 1|title 1|description 1|system 1|
      |name 2|title 2|description 2|system 2|
      |name 3|title 3|description 3|system 3|
      |name 4|title 4|description 4|system 4|
    When I delete the 3rd roles
    Then I should see the following roles:
      |Name|Title|Description|System|
      |name 1|title 1|description 1|system 1|
      |name 2|title 2|description 2|system 2|
      |name 4|title 4|description 4|system 4|
