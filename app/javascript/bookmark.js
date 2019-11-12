export default class Bookmark {

  constructor(state) {
    this.state = {
      parent: state.parent,
      has_bookmarked: state.has_bookmarked
    }
    this.authenticity_token = document.getElementsByName('csrf-token')[0].content
  }

  get _state() {
    return this.state
  }

  setState(new_state) {
    this.state = Object.assign(this.state, new_state)
  }

  create(entry_token) {
    const url = `/entries/${entry_token}/bookmarks`

    fetch(url, {
      method: 'POST',
      mode: 'same-origin',
      headers: {
        'Content-Type': 'application/json; charset=urf-8'
      },
      body: JSON.stringify({
        entry_token: entry_token,
        authenticity_token: this.authenticity_token
      })
    })
    .then((response) => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok.')
    })
    .then(() => {
      // ブックマーク成功時の処理
      this.setState({
        has_bookmarked: !this.state.has_bookmarked
      })
      this.state.parent.setAttribute('bookmarked', '')
      this.state.parent.innerHTML = this.render()
    })
    .catch((error) => console.error('error:', error))
  }

  destroy(entry_token) {
    const url = `/entries/${entry_token}/bookmarks`

    fetch(url, {
      method: 'DELETE',
      mode: 'same-origin',
      headers: {
        'Content-Type': 'application/json; charset=urf-8'
      },
      body: JSON.stringify({
        entry_token: entry_token,
        authenticity_token: this.authenticity_token
      })
    })
    .then((response) => {
      if (response.ok) {
        return response
      }
      throw new Error('Network response was not ok.')
    })
    .then(() => {
      // ブックマーク成功時の処理
      this.setState({
        has_bookmarked: !this.state.has_bookmarked
      })
      this.state.parent.removeAttribute('bookmarked')
      this.state.parent.innerHTML = this.render()
    })
    .catch((error) => console.error('error:', error))
  }

  render() {
    if (this.state.has_bookmarked) {
      return(
        '<div class="entry-page__bookmarked">' +
        '<i class="far fa-bookmark"></i>' +
        '</div>'
      )
    } else {
      return(
        '<div class="entry-page__not-bookmarked">' +
        '<i class="far fa-bookmark"></i>' +
        '</div>'
      )
    }
  }
}