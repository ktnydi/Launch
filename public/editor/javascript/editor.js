document.addEventListener('DOMContentLoaded', function() {

  var text_area = document.getElementById('post_content');

  var editor = CodeMirror.fromTextArea(text_area, {
    mode: "markdown",
    lineNumbers: true,
    lineWrapping: true,
    indentUnit: 2,
    theme: 'neat',
    styleActiveLine: true
  });
  editor.setSize("50%", "600px");

  const preview = document.getElementById('md-preview');
  editor.on('change', function(e) {
    preview.innerHTML = marked(e.getValue());
  });

  marked.setOptions({breaks: true});
  
});
