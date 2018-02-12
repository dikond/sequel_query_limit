require 'logger'

module DBHelper
  extend self

  def enable_sequel_extension
    Sequel::Database.extension(:query_limit)
  end

  def connect
    Object.const_set(:DB, Sequel.sqlite)
  end

  # https://github.com/jeremyevans/sequel/blob/master/lib/sequel/database/connecting.rb#L62
  def disconnect
    return unless defined?(DB) && DB.pool.available_connections.any?
    DB.disconnect
    Sequel.synchronize{::Sequel::DATABASES.delete(DB)}
  end

  def with_connection
    yield(Sequel::DATABASES.first || connect)
  end

  def create_db_schema
    with_connection do
      DB.create_table(:articles) do
        primary_key :id
        column :title, String, null: false
        column :body, String, null: false
      end

      DB.create_table(:comments) do
        primary_key :id
        foreign_key :article_id, :articles, null: false
        column :body, String, null: false
      end
    end
  end

  def init_models
    Object.class_eval <<~CODE
      class Article < Sequel::Model(:articles)
        one_to_many :comments
      end

      class Comment < Sequel::Model(:comments)
        many_to_one :article
      end
    CODE
  end

  def add_logger(logger = nil)
    with_connection do
      DB.loggers << (logger || Logger.new($stdout))
    end
  end
end
