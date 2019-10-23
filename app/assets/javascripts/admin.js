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
//= require jsviews/jsrender.min

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


$(function(){
  _Console = function(){
    this.tmpl = $.templates("#alert");
  }

  window.Console = new _Console()

  _Console.prototype.alert = function(key, val){
    var html = this.tmpl.render({
      key: key,
      value: val
    });
    $("#main").prepend(html)
  }

  _Console.prototype.alertSuccess = function(val){
    Console.alert("success", val)
  };

  _Console.prototype.alertError = function(val){
    Console.alert("danger", val)
  };

  _Console.prototype.alertWarning = function(val){
    Console.alert("warning", val)
  };
})