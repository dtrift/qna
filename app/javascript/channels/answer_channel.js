import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    var questionId = $('.question').data('question-id');
    this.perform('follow', { question_id: questionId });
  },

  disconnected() {

   },

  received(data) {
    console.log('Received data ->', data);
    var answerTemplate = pug.compile('templates/answer.jst.pug');

    // $('.answers').append(data)

    // var answerTemplate = handlebars.compile('answer-template');
    // $('.answers').append(answerTemplate({
    //   answer: data.answer,
    //   files: data.files,
    //   links: data.links
    // }))
    // $('.answers').repalceWith(JST['templates/answer']({
      // answer: data.answer,
      // user: data.user,
      // files: data.files,
      // links: data.links,
      // rating: data.score
    // }))
  }
});
