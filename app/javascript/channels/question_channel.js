import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    this.perform('question_channel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    $('.questions').append(data);
  }
});
