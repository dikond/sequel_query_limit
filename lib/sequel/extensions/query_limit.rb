require_relative '../../query_limit/sequel_extension'

module Sequel
  module Extensions
    Sequel::Database.register_extension(:query_limit, QueryLimit::SequelExtension)
  end
end
