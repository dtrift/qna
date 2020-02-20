import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    this.perform('question_channel');
  },

  disconnected() {
    return this.perform('unsubscribed');
  },

  received(data) {
    $('.questions').append(data);
  }
});
