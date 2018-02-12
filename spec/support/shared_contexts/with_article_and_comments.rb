RSpec.shared_context 'with article and comments' do
  let(:article)   { Article.create(title: "How I've created a super-useful gem", body: 'magic') }
  let(:comment_a) { article.add_comment(body: "Where did you learned such magic?") }
  let(:comment_b) { article.add_comment(body: 'Wow. Much magic. True ruby.') }
  let(:comment_c) { article.add_comment(body: "There is no magic! You're liar!") }
  let(:comments)  { [comment_a, comment_b, comment_c] }
end
