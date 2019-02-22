document.addEventListener('DOMContentLoaded', function() {
  hljs.initHighlightingOnLoad();
  marked_js_render();
});

function marked_js_render() {
  var renderer = new marked.Renderer();

  renderer.code = function (code, language) {
    return '<pre' + '><code class="hljs">' + hljs.highlightAuto(code, [language]).value + '</code></pre>';
  };
  marked.setOptions({
    breaks: true,
    renderer: renderer
  });
}
