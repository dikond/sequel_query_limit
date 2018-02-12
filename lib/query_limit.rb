require 'sequel/extensions/query_limit'
require 'query_limit/version'
require 'query_limit/configuration'

module QueryLimit
  extend self

  @configuration = Configuration.new

  def config
    @configuration
  end

  def configure(finalize: true)
    yield(@configuration)
    @configuration.finalize if finalize
    @configuration
  end

  def loggers
    @configuration.loggers
  end
end
