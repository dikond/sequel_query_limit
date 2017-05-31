require_relative 'analyzer'

module QueryLimit
  class Listener
    class Entry < Struct.new(:sql, :stacktrace); end

    attr_reader :stack

    def initialize
      @stack = []
    end

    def sequel_query(sql, stacktrace)
      @stack << Entry.new(sql, stacktrace)
    end

    class Global
      VAR_NAME = 'query_limit_spy'.freeze

      class << self
        def watch
          self.spy = Listener.new if spy.nil?
          Wisper.subscribe(spy, on: :sequel_query)
        end

        def sleep
          Wisper.unsubscribe(spy)
        end

        def die
          Wisper.unsubscribe(spy)
          self.spy = nil
        end

        def analyze(np1: true, reset: false)
          Analyzer.new(spy.stack).analyze_np1 if np1
          self.spy = Listener.new if reset
        end

        private

        def spy=(value)
          Thread.current.thread_variable_set(VAR_NAME, value)
        end

        def spy
          Thread.current.thread_variable_get(VAR_NAME)
        end
      end
    end
  end
end
