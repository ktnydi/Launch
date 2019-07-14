document.addEventListener('DOMContentLoaded', function() {
  const editor = document.getElementsByClassName('editor')[0]
  const preview = document.querySelectorAll('.editor_preview_content')[0]
  const draft = document.getElementById('draft')
  const public = document.getElementById('public')

  $('#category').selectize({
    delimiter: ',',
    persist: false,
    create: function(input) {
      return {
        value: input,
        text: input,
      }
    }
  })

  const scroll_sync = (e) => {
    const extra_scroll = (preview.scrollHeight - preview.clientHeight) / (editor.scrollHeight - editor.clientHeight)
    preview.scrollTop = editor.scrollTop * extra_scroll
  }

  editor.addEventListener('scroll', (e) => {
    scroll_sync(e)
  })

  editor.addEventListener('input', (e) => {
    scroll_sync(e)
  })

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
    .done( (data) => {
      window.location = data.url
    })
    .fail( (error) => {
    })
  }

  const update_draft = (article_token) => {
    $.ajax({
      type: 'PATCH',
      url: `/drafts/${article_token}`,
      data: {
        draft: {
          title: document.editor_form.title.value,
          category: document.editor_form.category.value,
          content: document.editor_form.content.value
        }
      }
    })
    .done( (data) => {
      window.location = data.url
    })
    .fail( (error) => {
    })
  }

  const delete_draft = () => {
    $.ajax({
      type: 'DELETE',
      url: `/drafts/${article_token()}`,
    })
    .done( (delete_success) => {
    })
    .fail( (error) => {
    })
  }

  const create_public = () => {
    $.ajax({
      type: 'POST',
      url: '/publics',
      data: {
        public: {
          article_token: article_token(),
          title: document.editor_form.title.value,
          category: document.editor_form.category.value,
          content: document.editor_form.content.value
        }
      }
    })
    .done( (new_public) => {
      delete_draft()
      const article_token = new_public.article_token
      window.location = `/publics/${article_token}`
    })
    .fail( (error) => {
      const list = document.getElementById('editor_errors_list')
      if (list.childNodes.length > 0) {
        list.innerHTML = null
      }
      const error_messages = error.responseJSON
      for (var i = 0; i < error_messages.length; i++) {
        const child_list = document.createElement('li')
        const error_message = error_messages[i]
        const child_list_text = document.createTextNode(error_message)
        child_list.appendChild(child_list_text)
        list.appendChild(child_list)
      }
      const editor_errors = document.getElementsByClassName('editor_errors')[0]
      editor_errors.classList.add('show')
      setTimeout( () => {
        editor_errors.classList.remove('show')
      }, 5000)
    })
  }

  const validation_of_presence = () => {
    if (document.editor_form.title.value === "" ) {
      return false
    } else {
      return true
    }
  }

  draft.addEventListener('click', (e)=>{
    e.preventDefault()
    if (!validation_of_presence()) {
      return alert('タイトルを入力してください')
    }

    if (article_token()) {
      update_draft(article_token())
    } else {
      create_draft()
    }
  })

  public.addEventListener('click', (e)=> {
    e.preventDefault()
    create_public()
  })

  const editor_preview = () => {
    if (editor.value.length >= 0) {
      preview.innerHTML = marked(editor.value)
    }
  }

  const show_restore_message = () => {
    const storage = localStorage
    const backup_title = storage.launch_backup_title
    const backup_content = storage.launch_backup_content
    const backup_time = storage.launch_backup_time
    const current_time = new Date().getTime()
    const since_backup = (current_time - backup_time) / (1000 * 60)
    if (backup_title || backup_content) {
      const time = document.getElementsByClassName('time')[0]
      time.textContent = Math.round(since_backup)
      const restore_message = document.getElementsByClassName('restore_message')[0]
      restore_message.classList.add('show')
    }
  }

  const backup_restore = () => {
    const storage = localStorage
    const title = storage.launch_backup_title
    const content = storage.launch_backup_content
    if (title || content) {
      document.editor_form.title.value = title
      document.editor_form.content.value = content
      preview.innerHTML = marked(content)
    }
  }

  document.getElementsByClassName('restore_btn')[0].addEventListener('click', () => {
    backup_restore()
  })

  show_restore_message()

  const backup_article = () => {
    const storage = localStorage
    if (editor.value.length >= 50) {
      storage.launch_backup_title = document.editor_form.title.value
      storage.launch_backup_content = document.editor_form.content.value
      storage.launch_backup_time = new Date().getTime()
      show_restore_message()
    }
  }

  var backup
  editor_preview()
  editor.addEventListener('input', ()=>{
    editor_preview()
    clearTimeout(backup)
    backup = setTimeout(backup_article, 5000)
  })
});
