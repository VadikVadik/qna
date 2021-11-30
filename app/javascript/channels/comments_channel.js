import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  let url = document.URL.split('/').reverse()

  if(url.includes('questions')) {
    consumer.subscriptions.create({channel: "CommentsChannel", question_id: url[0]},
                                  {connected() {
                                    this.perform('follow')
                                   },
                                   received(data) {
                                     let commentable = data.commentable_type.toLowerCase();
                                     if(commentable == 'question'){
                                       $('.question-comments').append('<li>' + data.body + '</li>');
                                     }else if (commentable == 'answer') {
                                       $('#answer-' + data.commentable_id + ' .answer-comments').append('<li>' + data.body + '</li>');
                                     }
                                     $('.new-comment #body').val('');
                                   }
                                  })
  }
});
