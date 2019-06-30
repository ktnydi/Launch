// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require_tree .

document.addEventListener('DOMContentLoaded', () => {
  const headings = document.querySelectorAll(`
    .box_content h1,
    .box_content h2,
    .box_content h3
  `)
  const toc = document.getElementsByClassName('toc')[0]

  for (let i = 0; i < headings.length; i++) {
    const heading = headings.item(i)
    heading.id = `chapter_${i + 1}`

    if (heading.nodeName === 'H1') {
      var h1_ul = document.createElement('ul')
      var h1_li = document.createElement('li')
      var h1_a = document.createElement('a')
      var h1_a_text = document.createTextNode(heading.textContent)
      h1_ul.setAttribute('class', 'heading1')
      h1_a.setAttribute('href', `#chapter_${i + 1}`)
      h1_a.setAttribute('class', `chapter`)
      h1_a.dataset.innerlink = `chapter_${i + 1}`
      h1_a.appendChild(h1_a_text)
      h1_li.appendChild(h1_a)
      h1_ul.appendChild(h1_li)
      toc.appendChild(h1_ul)
    }

    if (heading.nodeName === 'H2') {
      var h2_ul = document.createElement('ul')
      var h2_li = document.createElement('li')
      var h2_a = document.createElement('a')
      var h2_a_text = document.createTextNode(heading.textContent)
      h2_ul.setAttribute('class', 'heading2')
      h2_a.setAttribute('href', `#chapter_${i + 1}`)
      h2_a.setAttribute('class', `chapter`)
      h2_a.dataset.innerlink = `chapter_${i + 1}`
      h2_a.appendChild(h2_a_text)
      h2_li.appendChild(h2_a)
      h2_ul.appendChild(h2_li)

      var h1_last_ul = toc.lastElementChild
      var h1_last_li = h1_last_ul.lastElementChild

      h1_last_li.appendChild(h2_ul)
    }

    if (heading.nodeName === 'H3') {
      var h3_ul = document.createElement('ul')
      var h3_li = document.createElement('li')
      var h3_a = document.createElement('a')
      var h3_a_text = document.createTextNode(heading.textContent)
      h3_ul.setAttribute('class', 'heading3')
      h3_a.setAttribute('href', `#chapter_${i + 1}`)
      h3_a.setAttribute('class', `chapter`)
      h3_a.dataset.innerlink = `chapter_${i + 1}`
      h3_a.appendChild(h3_a_text)
      h3_li.appendChild(h3_a)
      h3_ul.appendChild(h3_li)
      var h1_last_ul = toc.lastElementChild
      var h1_last_li = h1_last_ul.lastElementChild
      var h2_last_ul = h1_last_li.lastElementChild
      var h2_last_li = h2_last_ul.lastElementChild

      h2_last_li.appendChild(h3_ul)
    }
  }

  $(function() {
    $('.chapter').click(function() {
      const speed = 400
      const href = $(this).attr('href')
      const target = $(href == '#' || href == '' ? 'html' : href)
      const position = target.offset().top - target.height()
      $('body, html').animate({scrollTop:position}, speed, 'swing')
      return false
    })
  })
})
