document.addEventListener('DOMContentLoaded', function() {
  const editor = document.getElementsByClassName('editor')[0]
  const preview = document.querySelectorAll('.editor_preview')[0]
  const draft = document.getElementsByClassName('draft')[0]
  const public = document.getElementsByClassName('public')[0]

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
      console.log(new_draft)
      window.location = `/drafts/${new_draft.article_token}`
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
    .done( (edit_draft) => {
      window.location = `/drafts/${edit_draft.article_token}`
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
      console.log(error)
    })
  }

  const validation_of_presence = () => {
    if (document.editor_form.title.value === "" ) {
      document.editor_form.submit.click()
      return false
    } else {
      return true
    }
  }

  draft.addEventListener('click', (e)=>{
    e.preventDefault()
    if (!validation_of_presence()) {
      return
    }

    if (article_token()) {
      update_draft(article_token())
    } else {
      create_draft()
    }
  })

  public.addEventListener('click', (e)=> {
    e.preventDefault()
    if (validation_of_presence()) {
      create_public()
    }
  })

  const editor_preview = () => {
    if (editor.value.length > 0) {
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
    if (title || content) {
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
