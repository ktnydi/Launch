document.addEventListener('DOMContentLoaded', function() {
  const editor = document.getElementsByClassName('editor')[0]
  const preview = document.querySelectorAll('.editor_preview .preview_content')[0]
  const autosave = document.getElementsByClassName('autosave')[0]
  const autosave_message = document.getElementsByClassName('autosave_message')[0]

  const editor_preview = () => {
    if (editor.value.length > 0) {
      preview.innerHTML = marked(editor.value)
    }
  }

  const auto_save = () => {
    autosave.click()
  }

  const hide_autosave_message = () => {
    autosave_message.classList.remove('save')
  }

  var save
  editor_preview()
  editor.addEventListener('input', ()=>{
    editor_preview()
    clearTimeout(save)
    save = setTimeout(auto_save, 3000)
  })

  document.addEventListener('ajax:success', (e)=>{
    console.log('success')
    autosave_message.classList.add('save')
    setTimeout(hide_autosave_message, 5000)
  })
});
