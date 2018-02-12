require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run all except integration specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--exclude-pattern spec/integration/**/*.rb'
end
task :default => :spec

namespace :spec do
  desc 'Run integration specs'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.rspec_opts = '--pattern spec/integration/**/*_spec.rb'
  end
end
