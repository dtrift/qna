import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    var questionId = $('.question').data('question-id');
    this.perform('follow', { question_id: questionId });
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('Received')

    // if gon.current_user && (gon.current_user.id != data.user)

    // $('.answers').repalceWith(JST['templates/answer']({
      // answer: data.answer,
      // user: data.user,
      // files: data.files,
      // links: data.links,
      // rating: data.score
    // }))
  }
});
