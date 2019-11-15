/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import Bookmark from '../bookmark'
import Like from '../like'

document.addEventListener('DOMContentLoaded', ()=>{
  const parent_like = document.getElementById('like')
  const like_state = {
    parent_elem: parent_like,
    entry_token: parent_like.dataset.entrytoken,
    sum_like_count: Number(parent_like.dataset.sumlikecount),
    add_like_count: Number(parent_like.dataset.addlikecount)
  }
  const like = new Like(like_state)

  const parent_bookmark = document.getElementById('bookmark')
  const state = {
    parent: parent_bookmark,
    has_bookmarked: parent_bookmark.hasAttribute('bookmarked')
  }
  const bookmark = new Bookmark(state)

  parent_like.innerHTML = like.render()
  bookmark._state.parent.innerHTML = bookmark.render()

  parent_like.addEventListener('click', ()=>{
    if (like._state.add_like_count > 0) {
      like.update(like._state.entry_token)
    } else {
      like.create(like._state.entry_token)
    }
  })

  bookmark._state.parent.addEventListener('click', ()=>{
    if (bookmark._state.has_bookmarked) {
      // bookmark削除のリクエスト
      bookmark.destroy(bookmark._state.parent.dataset.entrytoken)
    } else {
      // bookmark作成のリクエスト
      bookmark.create(bookmark._state.parent.dataset.entrytoken)
    }
  })
})
