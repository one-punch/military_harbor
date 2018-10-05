//= require jquery
//= require jquery-ui
//= require rails-ujs
//= require turbolinks
//= require bootstrap-fileinput/js/plugins/piexif.js
//= require bootstrap-fileinput/js/plugins/sortable.min.js
//= require bootstrap-fileinput/js/plugins/purify.min.js
//= require bootstrap-fileinput/js/fileinput.min.js
//= require bootstrap
//= require bootstrap-fileinput/themes/fa/theme.js
//= require simditor

function add_fields(link, association, content) {
  console.log($(link).parent())
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
}

function remove_fields(link) {
  console.log($(link).prev().attr('id'))
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}
