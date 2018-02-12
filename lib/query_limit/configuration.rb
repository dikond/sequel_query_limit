require 'logger'

module QueryLimit
  class Configuration
    def initialize
      @loggers = []
      @loggers << Logger.new($stdout)
      @include_full_stacktrace = false
    end

    attr_accessor :loggers, :include_full_stacktrace

    def finalize
      @loggers.freeze
      freeze
    end
  end
end
