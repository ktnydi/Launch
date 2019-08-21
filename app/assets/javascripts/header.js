document.addEventListener('DOMContentLoaded', ()=>{
  const search = document.getElementById('search_focus')

  document.addEventListener('click', ()=>{
    if (search.classList.contains('focus')) {
      search.classList.remove('focus')
    }
  })

  search.addEventListener('click', (e)=>{
    e.stopPropagation()
    const target = e.currentTarget
    if (target === search) {
      target.classList.add('focus')
    }
  })
})
