require 'integration_helper'
require 'support/shared_contexts/with_article_and_comments'

RSpec.describe 'Global listener analysis', type: :integration do
  include_context 'with article and comments'

  before { comments && QueryLimit::Listener::Global.watch }
  after { QueryLimit::Listener::Global.die }

  it 'outputs info about found problems via loggers' do
    orig_loggers = QueryLimit.config.loggers
    log = StringIO.new
    QueryLimit.config.loggers = [Logger.new(log)]

    article.comments_dataset.all.each { |c| c.article.title }
    QueryLimit::Listener::Global.analyze(np1: true)

    log.rewind
    expect(log.read).to include "Possible N+1 query has been detected!\n" \
      "Following query was repeated 3 times:\n\n" \
      "SELECT * FROM `articles` WHERE `id` = 1"

    QueryLimit.config.loggers = orig_loggers
  end
end
