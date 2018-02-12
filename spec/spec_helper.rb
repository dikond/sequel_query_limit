require "bundler/setup"
require "sequel"
require "query_limit"

RSpec.configure do |config|
  Kernel.srand config.seed

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.order = :random

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
