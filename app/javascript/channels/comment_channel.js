import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    var questionId = $('.question').data('question-id');
    this.perform('follow', { question_id: questionId });
  },

  received(data) {
    var resource = $('.question-comments');

    if ((resource) && (data['comment']['user_id'] != gon.current_user)) {
      var comment = renderComment(data['comment'], data['user_email']);
      resource.append(comment);
    };
  }
});

function renderComment(comment, user_email) {
  var sections = `
  <div class="comment" data-id="${comment['id']}">
    <p>${comment['content']}</p> 
    <p>Author: ${user_email}</p>
  `;

  sections += '</div>'
  return sections;
};
