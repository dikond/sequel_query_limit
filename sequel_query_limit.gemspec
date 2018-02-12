require './lib/query_limit/version'

Gem::Specification.new do |spec|
  spec.name          = 'sequel_query_limit'
  spec.version       = QueryLimit::VERSION
  spec.authors       = 'dikond'
  spec.email         = 'di.kondratenko@gmail.com'

  spec.summary       = 'Helps to watch for N+1 queries in Sequel'
  spec.homepage      = 'https://github.com/dikond/sequel_query_limit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_runtime_dependency     'sequel', '>= 4.0', '< 6.0'
  spec.add_runtime_dependency     'wisper', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
