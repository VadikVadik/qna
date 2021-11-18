$(document).on('turbolinks:load', function () {

  $('.question').on('click', '.edit-question-link', function (event) {
    event.preventDefault();
    $(this).hide();

    let questionId = $(this).data('questionId');

    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  $('.answers').on('click', '.edit-answer-link', function (event) {
    event.preventDefault();
    $(this).hide();

    let answerId = $(this).data('answerId');

    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

// ajax добавление ответов

  $('form.new-answer').on('ajax:success', function (e) {
    answer = e.detail[0];

    $('.answers').append('<p>' + answer.body + '</p>');
  })
    .on('ajax:error', function (e) {
      errors = e.detail[0];

      $.each(errors, function (index, value) {
        $('.answer-errors').html('').append('<p>' + value + '</p>');
      })
    })

// ajax голосование

  $('.for-question-link, .against-question-link, .change-question-vote').on('ajax:success', function (e) {
    vote = e.detail[0];

    $('.question-rating-error').html('');
    $('.question-rating').text('Rating: ' + vote.votable_rating);
  })
    .on('ajax:error', function (e) {
      error = e.detail[0];

      $('.question-rating-error').html('').append('<p>' + error + '</p>');
    })

  $('.for-answer-link, .against-answer-link, .change-answer-vote').on('ajax:success', function (e) {
    vote = e.detail[0];

    $('.answer-rating-error').html('');
    $('#answer-' + vote.votable_id + ' .answer-rating').text('Rating: ' + vote.votable_rating);
  })
    .on('ajax:error', function (e) {
      error = e.detail[0];

      $('.answer-rating-error').html('').append('<p>' + error + '</p>');
    })
});
