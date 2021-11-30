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
  $('.vote-for-link, .vote-against-link, .change-vote-link').on('ajax:success', function (e) {
    vote = e.detail[0];
    votable = vote.votable_type.toLowerCase();

    $('.' + votable + '-rating-error').html('');

    if(votable == 'question') {
      $('.question-rating').text('Rating: ' + (vote.votable_rating + parseInt(vote.status, 10)));
    } else if(votable == 'answer') {
      $('#answer-' + vote.votable_id + ' .answer-rating').text('Rating: ' + (vote.votable_rating + parseInt(vote.status, 10)));
    }
  })
    .on('ajax:error', function (e) {
      if(typeof e.detail[0] == "object") {
        info = e.detail[0];
        error = info.errors;
        votable = info.votable_type.toLowerCase();
        votable_id = info.votable_id;
      } else {
        error = e.detail[0];
        votable = '';
      }

      if(votable == 'question') {
        $('.question-rating-error').html('').append('<p>' + error + '</p>');
      } else if(votable == 'answer') {
        $('#answer-' + votable_id + ' .answer-rating-error').html('').append('<p>' + error + '</p>');
      } else {
        $('.unauth-voting-alert').html('').append('<p>' + error + '</p>');
        window.scrollTo(top);
      }
    })

// ajax comments errors
  $('form.new-comment').on('ajax:error', function (e) {
    if(typeof e.detail[0] == "object") {
      info = e.detail[0];
      error = info.errors;
      commentable = info.commentable_type.toLowerCase();
      commentable_id = info.commentable_id;
    } else {
      error = e.detail[0];
      commentable = '';
    }

    if(commentable == 'question') {
      $('.question-comments-error').html('').append('<p>' + error + '</p>');
    } else if(commentable == 'answer') {
      $('#answer-' + commentable_id + ' .answer-comments-error').html('').append('<p>' + error + '</p>');
    } else {
      $('.unauth-voting-alert').html('').append('<p>' + error + '</p>');
      window.scrollTo(top);
    }
  })
});
