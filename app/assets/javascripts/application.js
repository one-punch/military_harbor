// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require popper/popper.min.js
//= require bootstrap
//= require rails-ujs
//= require turbolinks
//= require cable
//= require jquery.toaster/jquery.toaster.js
//= require choices/choices.min
//= require geetest/gt
//= require qrcode/qrcode.min.js
//= require jquery.simple.timer/jquery.simple.timer.js


function makeQrcode(el, options, elText) {
  var qrcode = new QRCode(el, options);
  qrcode.makeCode(elText);
}

function timer(selector, callback){
  $(selector).startTimer({
      onComplete: callback
  });
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

  _Console.prototype.makeQrcode = function(el, options, elText){
    makeQrcode(el, options, elText)
  }

  _Console.prototype.startTimer = function(selector, callback){
    timer(selector, callback)
  }

  $(document).on("click", ".print-pdf", function(){
    window.print()
  })
})