require 'cucumber/thinking_sphinx/external_world'
require "authlogic/test_case"
Cucumber::ThinkingSphinx::ExternalWorld.new
Cucumber::Rails::World.use_transactional_fixtures = false

