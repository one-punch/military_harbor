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
//= require jquery.toaster/jquery.toaster.js


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
  }

  window.Console = new _Console()

  _Console.prototype.alert = function(key, val){
    $.toaster({ message : val, priority : key });
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

  $('.select2').each(function(i, e){
    var config = {
      placeholder: 'Search for a repository',
      minimumInputLength: 2,
      allowClear: true,
      templateResult: formatRepo,
      templateSelection: formatRepoSelection,
      closeOnSelect: true,
      ajax: {
        delay: 250,
        url: function (params) {
          return $(this).data("path")
        },
        dataType: 'json',
        data: function (params) {
          var query = {
            q: params.term,
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
    };
    Object.assign(config, {
      closeOnSelect: $(e).data("closeonselect") !== undefined ? $(e).data("closeonselect") : true
    });
    $(e).select2(config);
  });

})