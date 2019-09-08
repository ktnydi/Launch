document.addEventListener('DOMContentLoaded', ()=>{
  const all_checked = document.getElementById('all_checked')
  const delete_check_boxes = document.getElementsByClassName('delete_check_box')
  const delete_select_article = document.getElementsByClassName('delete_select_article')[0]
  const table_containers = document.getElementsByClassName('table_container')
  const check_box_labels = document.getElementsByClassName('check_box_label')

  const has_checked_checkbox = () => {
    for (let i = 0; i < delete_check_boxes.length; i++) {
      const delete_check_box = delete_check_boxes.item(i)

      if (delete_check_box.checked) {
        return true
      }
    }
    return false
  }

  const delete_draft_articles = (article_ids) => {
    const authenticity_token = document.getElementsByName('authenticity_token')[0].value
    fetch('/drafts/destroy', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({article_ids: article_ids, "authenticity_token": authenticity_token})
    })
    .then(window.location.reload())
  }

  const delete_public_articles = (article_ids) => {
    const authenticity_token = document.getElementsByName('authenticity_token')[0].value
    fetch('/publics/destroy', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({article_ids: article_ids, "authenticity_token": authenticity_token})
    })
    .then(window.location.reload())
  }

  all_checked.addEventListener('click', ()=>{
    for (let i = 0; i < delete_check_boxes.length; i++) {
      const delete_check_box = delete_check_boxes.item(i)
      delete_check_box.checked = all_checked.checked

      if (delete_check_box.checked) {
        delete_select_article.classList.add('active')
      } else {
        delete_select_article.classList.remove('active')
      }
    }
  })

  for (let i = 0; i < delete_check_boxes.length; i++) {
    const delete_check_box = delete_check_boxes.item(i)

    delete_check_box.addEventListener('change', ()=>{
      if (has_checked_checkbox()) {
        delete_select_article.classList.add('active')
      } else {
        delete_select_article.classList.remove('active')
      }
    })
  }

  delete_select_article.addEventListener('click', ()=>{
    const confirm = window.confirm('本当に削除しますか？')
    if (confirm === false) {
      return
    }

    let select_article_ids = []
    for (let i = 0; i < delete_check_boxes.length; i++) {
      const delete_check_box = delete_check_boxes.item(i)

      if (delete_check_box.checked) {
        select_article_ids.push(delete_check_box.dataset.articleid)
      }
    }

    if (delete_select_article.dataset.mode === 'draft') {
      delete_draft_articles(select_article_ids)
    }

    if (delete_select_article.dataset.mode === 'public') {
      delete_public_articles(select_article_ids)
    }
  })

  for (let i = 0; i < check_box_labels.length; i++) {
    const check_box_label = check_box_labels.item(i)
    check_box_label.addEventListener('click', (e)=>{
      e.stopPropagation()
    })
  }

  for (let i = 0; i < table_containers.length; i++) {
    const table_container = table_containers.item(i)
    table_container.addEventListener('click', (e)=>{
      if (!e.target.classList.contains('delete_check_box')) {
        window.location.href = table_container.dataset.url
      }
    })
  }
})
