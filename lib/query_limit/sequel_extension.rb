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
      result = nil

      Wisper.subscribe(listener, on: :sequel_query) { result = yield }

      return result if listener.grep(pattern).size <= max
      raise QueryLimit::Errors::MaxQueriesLimitReached
    end
  end
end
