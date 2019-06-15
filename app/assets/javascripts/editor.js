document.addEventListener('DOMContentLoaded', function() {
  const editor = document.getElementsByClassName('editor')[0]
  const preview = document.querySelectorAll('.editor_preview .preview_content')[0]

  if (editor.value.length > 0) {
    preview.innerHTML = marked(editor.value)
  }
  editor.addEventListener('input', ()=>{
    preview.innerHTML = marked(editor.value)
  })
});
