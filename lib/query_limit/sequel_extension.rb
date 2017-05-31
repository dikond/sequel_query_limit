require 'wisper'
require_relative 'listener'
require_relative 'errors'

module QueryLimit
  module SequelExtension
    include Wisper::Publisher

    def log_connection_yield(sql, conn, args = nil)
      broadcast(:sequel_query, sql, caller)
      super
    end

    def with_query_limit(pattern, max:)
      listener = QueryLimit::Listener.new

      Wisper.subscribe(listener, on: :sequel_query) { yield }

      raise QueryLimit::Errors::ExceedingMaxError if listener.stack.grep(pattern).size > max
    end
  end
end
