require 'integration_helper'
require 'support/shared_contexts/with_article_and_comments'

RSpec.describe 'Sequel DB extension', type: :integration do
  describe '.with_query_limit' do
    include_context 'with article and comments'

    subject(:result) do
      DB.with_query_limit(/SELECT \* FROM `articles` WHERE `id` = 1/, max: limit) do
        article.comments_dataset.all.map { |c| c.article.title }.uniq
      end
    end

    before { comments  }

    context 'when query exceeds the limit' do
      let(:limit) { 1 }

      it { expect { result }.to raise_error(QueryLimit::Errors::MaxQueriesLimitReached) }
    end

    context 'when query does not exceeds the limit' do
      let(:limit) { 10 }

      it 'returns the result of the query unless it exceeds the limit' do
        expect(result).to eq [article.title]
      end
    end
  end
end
