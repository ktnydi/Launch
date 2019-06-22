document.addEventListener('DOMContentLoaded', function() {
  const editor = document.getElementsByClassName('editor')[0]
  const preview = document.querySelectorAll('.editor_preview')[0]
  const draft = document.getElementsByClassName('draft')[0]
  const public = document.getElementsByClassName('public')[0]
  const autosave = document.getElementsByClassName('autosave')[0]

  const editor_preview = () => {
    if (editor.value.length > 0) {
      preview.innerHTML = marked(editor.value)
    }
  }

  const article_token = () => {
    var path = window.location.pathname
    var has_token = path.match(/\/drafts\/(\w+)\/edit/)
    var token = has_token ? has_token[1] : ''
    return token
  }

  const create_draft = () => {
    $.ajax({
      type: 'POST',
      url: '/drafts',
      data: {
        draft: {
          title: document.editor_form.title.value,
          category: document.editor_form.category.value,
          content: document.editor_form.content.value
        }
      }
    })
    .done( (new_draft) => {
      console.log('success')
      const article_token = new_draft.article_token
      const edit_draft_path = `/drafts/${article_token}/edit`
      history.replaceState(null, null, edit_draft_path)
    })
    .fail( (error) => {
      console.log(error)
    })
  }

  const update_draft = () => {
    $.ajax({
      type: 'PATCH',
      url: `/drafts/${article_token()}`,
      data: {
        draft: {
          title: document.editor_form.title.value,
          category: document.editor_form.category.value,
          content: document.editor_form.content.value
        }
      }
    })
    .done( (edit_draft) => {
      console.log('success')
      console.log(edit_draft)
    })
    .fail( (error) => {
      console.log(error)
    })
  }

  draft.addEventListener('click', (e)=>{
    e.preventDefault()
    update_draft()
    window.location = `/drafts/${article_token()}`
  })

  const public_save = () => {
  }

  const auto_save = () => {
    if (article_token()) {
      update_draft()
    } else {
      create_draft()
    }
  }

  var save
  editor_preview()
  editor.addEventListener('input', ()=>{
    editor_preview()
    clearTimeout(save)
    save = setTimeout(auto_save, 3000)
  })
});
