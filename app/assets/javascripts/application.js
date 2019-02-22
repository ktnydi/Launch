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
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

document.addEventListener('DOMContentLoaded', function() {
  var now_url = location.href;
  var lists = document.querySelectorAll('.header-left ul li');
  for (var i = 0; i < lists.length; i++) {
    var a = lists.item(i).firstElementChild;
    if (a.href === now_url) {
      lists.item(i).className = 'active';
      break;
    }
  }

  var toggle = document.getElementById('toggle');
  var lists = document.getElementById('lists');
  toggle.addEventListener('click', function() {
    var classes = lists.className.split(' ');
    var active_idx = classes.indexOf('active');
    if (active_idx >= 0) {
      classes.splice(active_idx, 1);
      lists.className = classes.join(' ');
    } else {
      classes.push('active');
      lists.className = classes.join(' ');
    }
  });

  const NOTIFICATION = document.getElementById('notification');

  if (NOTIFICATION !== null) {
    setTimeout(
      function() {
        var classes = NOTIFICATION.className.split(' ');
        classes.push('close');
        NOTIFICATION.className = classes.join(' ');
      },
      3000
    );
  }
});
