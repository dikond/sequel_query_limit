module QueryLimit
  class Analyzer
    MATCHER = %r{\A(SELECT\s.*\sFROM\s.*\sWHERE\s)(.*)\z}

    attr_reader :stack

    def initialize(stack)
      @stack = stack
    end

    def analyze_np1
      grp = stack.group_by { |entry| entry.sql.match(MATCHER)&.captures&.at(1) }
      diff = grp.values.find { |entries| entries.size > 1 }

      tell_the_story(diff) if diff
    end

    private

    def tell_the_story(diff)
      query      = diff.first.sql
      stacktrace = diff.first.stacktrace

      puts
      puts 'Possible N+1 query has been detected!'
      puts "Follwoing query was reapeated #{diff.size} times:"
      puts
      puts "#{query}"
      puts
      puts stacktrace.reject { |s| s.include? 'gem' }.map { |s| "    #{s}"}.join("\n")
      puts
    end
  end
end
