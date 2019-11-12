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

document.addEventListener('DOMContentLoaded', ()=>{
  const parent_bookmark = document.getElementById('bookmark')
  const state = {
    parent: parent_bookmark,
    has_bookmarked: parent_bookmark.hasAttribute('bookmarked')
  }
  const bookmark = new Bookmark(state)
  bookmark._state.parent.innerHTML = bookmark.render()

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
