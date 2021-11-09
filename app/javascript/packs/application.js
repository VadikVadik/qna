// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "@nathanvda/cocoon"
import "../stylesheets/application"
import "../utilities/edit_resource.js"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

jQuery.ajaxSetup({
  beforeSend: function(xhr) {
    $('#spinner').show();
  },
  // runs after AJAX requests complete, successfully or not
  complete: function(xhr, status){
    $('#spinner').hide();
  }
});
