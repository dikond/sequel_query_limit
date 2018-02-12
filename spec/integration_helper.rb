require 'spec_helper'
require 'support/db_helper'

RSpec.configure do |config|
  config.before(:suite) do
    DBHelper.enable_sequel_extension
    DBHelper.create_db_schema
    DBHelper.init_models
  end

  config.around(:example) do |example|
    DBHelper.with_connection do
      DB.transaction do
        begin
          example.run
        ensure
          raise Sequel::Rollback
        end
      end
    end
  end
end
