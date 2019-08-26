document.addEventListener('DOMContentLoaded', ()=>{
  const comment_edit_btn = document.getElementsByClassName('comment_edit_btn')[0]
  const preview_show_btn = document.getElementsByClassName('preview_show_btn')[0]
  const comment_edit_area = document.getElementsByClassName('comment_edit_area')[0]
  const preview_area = document.getElementsByClassName('preview_area')[0]

  const doToggleView = (e) => {
    if (e.target.classList.contains('current')) {
      return
    }

    // ボタンの切り替え
    comment_edit_btn.classList.toggle('current')
    preview_show_btn.classList.toggle('current')

    // ビューの切り替え
    comment_edit_area.classList.toggle('hide')
    preview_area.classList.toggle('hide')
  }

  preview_show_btn.addEventListener('click', (e)=>{
    doToggleView(e)
  })

  comment_edit_btn.addEventListener('click', (e)=>{
    doToggleView(e)
  })

  comment_edit_area.addEventListener('input', ()=>{
    preview_area.innerHTML = marked(comment_edit_area.value)
  })
})
