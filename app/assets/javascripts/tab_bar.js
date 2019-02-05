document.addEventListener('DOMContentLoaded', function() {

  // function getSelectedString(elem, event) {
  //   var selected_string = "";
  //   elem.addEventListener(event, function() {
  //     var start = elem.selectionStart;
  //     var end = elem.selectionEnd;
  //     var value = elem.value;
  //     if (start !== end) {
  //       selected_string = value.slice(start, end);
  //     }
  //   });
  // }

  function selectedStringIn(text_area) {
    var start = text_area.selectionStart;
    var end = text_area.selectionEnd;
    var value = text_area.value;
    return selected_string = value.slice(start, end);
  }

  var text_area = document.getElementById('post_content');

  var str = "";
  text_area.addEventListener('keyup', function() {
    str = selectedStringIn(text_area);
  });

  text_area.addEventListener('mouseup', function() {
    str = selectedStringIn(text_area);
  });

  var bold = document.getElementById('bold');
  bold.addEventListener('click', function() {
    console.log(str);
  });
});
