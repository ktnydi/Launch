document.addEventListener('DOMContentLoaded', function() {

  function selectedStr(text_area) {
    var start = text_area.selectionStart;
    var end   = text_area.selectionEnd;
    var val   = text_area.value;
    var selected_str = val.slice(start, end);
    return {val: val, start: start, end: end, str: selected_str};
  }

  function insertStr(insert, textarea) {
    var str    = selectedStr(text_area);
    var val    = str['val'];
    var before = val.substr(0, str['start']);
    var after  = val.slice(str['end'], val.length);
    val = before + insert + str['str'] + insert + after;
    return val
  }

  var text_area = document.getElementById('post_content');
  var bold      = document.getElementById('bold');
  bold.addEventListener('click', function() {
    text_area.value = insertStr('**', text_area);
  });

  var editor = CodeMirror.fromTextArea(text_area, {
    mode: "markdown",
    lineNumbers: true,
    lineWrapping: true,
    indentUnit: 2,
    theme: 'neat',
    styleActiveLine: true
  });

  editor.setSize("50%", "600px");
  editor.save();

});
