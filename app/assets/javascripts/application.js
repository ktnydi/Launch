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

  hljs.initHighlightingOnLoad();
  marked_js_render();
});

function marked_js_render() {
  var renderer = new marked.Renderer();

  renderer.code = function (code, language) {
    return '<pre' + '><code class="hljs">' + hljs.highlightAuto(code).value + '</code></pre>';
  };
  marked.setOptions({
    breaks: true,
    renderer: renderer
  });
}
