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
//= require select2/js/select2.full.min

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


function formatRepo (repo) {
  if (repo.loading) {
    return repo.text;
  }

  var $container = $(
    "<div class='select2-result-repository clearfix'>" +
      "<div class='select2-result-repository__avatar'></div>" +
      "<div class='select2-result-repository__meta'>" +
        "<div class='select2-result-repository__title'></div>" +
      "</div>" +
    "</div>"
  );

  $container.find(".select2-result-repository__title").text(repo.text);

  return $container;
}

function formatRepoSelection (repo) {
  return repo.text;
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

  $('.select2').select2({
    placeholder: 'Search for a repository',
    minimumInputLength: 2,
    templateResult: formatRepo,
    templateSelection: formatRepoSelection,
    ajax: {
      delay: 250,
      url: '/admin/ajax_select/category',
      dataType: 'json',
      data: function (params) {
        var query = {
          q: params.term,
          type: 'public',
          page: params.page || 1
        }

        return query;
      },
      processResults: function (data, params) {
        params.page = params.page || 1;

        return {
            results: data.results,
            pagination: {
                more: data.more
            }
        };
      },
      cache: true
    }
  });

})