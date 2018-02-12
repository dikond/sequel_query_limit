module QueryLimit
  class Analyzer
    MATCHER = %r{\A(SELECT\s.*\sFROM\s.*\sWHERE\s)(.*)\z}

    attr_reader :stack

    def initialize(stack)
      @stack = stack
    end

    def analyze_np1
      grp = stack.group_by { |entry| entry.sql.match(MATCHER)&.captures&.at(1) }
      grp.delete(nil) # ignore queries which does not satisfy MATCHER

      diff = grp.values.max_by(&:size)
      return if diff.size < 2

      tell_the_story(diff) if diff
      nil
    end

    private

    def tell_the_story(diff)
      query = diff.first.sql
      trace = format_stacktrace(diff.first.stacktrace)

      msg = <<~MSG
        Possible N+1 query has been detected!
        Following query was repeated #{diff.size} times:

        #{query}

        #{trace}
      MSG

      QueryLimit.loggers.each { |l| l.debug(msg) }
      nil
    end

    def format_stacktrace(stacktrace)
      unless QueryLimit.config.include_full_stacktrace
        stacktrace = stacktrace.reject { |s| s.include? 'gem' }
      end

      stacktrace.map { |s| "    #{s}"}.join("\n")
    end
  end
end
