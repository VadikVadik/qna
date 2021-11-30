import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  let url = document.URL.split('/').reverse()

  if(url.includes('questions')) {
    consumer.subscriptions.create({channel: "AnswersChannel", question_id: url[0]},
                                  {connected() {
                                    this.perform('follow')
                                   },
                                   received(data) {
                                     $('.answers').append(data);
                                   }

                                  })
  }
});
